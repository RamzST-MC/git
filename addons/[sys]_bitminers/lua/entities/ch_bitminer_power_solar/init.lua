AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/bitminers/power/solar_panel.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:GetPhysicsObject():Wake()
	
	self:SetHP( CH_Bitminers.Config.SolarPanelHealth )
	self:SetWattsGenerated( 0 )
	self:SetPowerOn( true )
	
	self.IsPluggedIn = false
	self.ConnectedEntity = nil
	
	self:CPPISetOwner( self.ItemOwner )
end

function ENT:SolarPluggedIn()
	-- Remove watt decrease timer
	if timer.Exists( "bitminer_solar_decreasewatts_".. self:EntIndex() ) then
		timer.Remove( "bitminer_solar_decreasewatts_".. self:EntIndex() )
	end
	
	-- Start generating power/watts
	self:GenerateWatts()
	
	-- Set shelf power source status
	if IsValid( self.ConnectedEntity ) then
		if IsValid( self.ConnectedEntity.Parent.ConnectedEntity ) then
			local connected_shelf = self.ConnectedEntity.Parent.ConnectedEntity
			
			if connected_shelf:GetClass() != "ch_bitminer_shelf" then
				return
			end
			
			connected_shelf:SetHasPower( true )
		end
	end
end

function ENT:SolarPluggedOut()	
	-- Remove watt generator timer
	if timer.Exists( "bitminer_solar_generatewatts_".. self:EntIndex() ) then
		timer.Remove( "bitminer_solar_generatewatts_".. self:EntIndex() )
	end
	
	-- Turn off green light
	self:SetSkin( 0 )
	
	-- Start decreasing watts
	self:DecreaseWatts()
	
	-- Set shelf power source status
	if IsValid( self.ConnectedEntity ) then
		if IsValid( self.ConnectedEntity.Parent.ConnectedEntity ) then
			local connected_shelf = self.ConnectedEntity.Parent.ConnectedEntity
			
			if connected_shelf:GetClass() != "ch_bitminer_shelf" then
				return
			end
			
			connected_shelf:SetHasPower( false )
			
			if connected_shelf:GetIsMining() then
				connected_shelf:PowerOff()
			end
		end
	end
end

function ENT:GenerateWatts()
	timer.Create( "bitminer_solar_generatewatts_".. self:EntIndex(), CH_Bitminers.Config.SolarPanelWattsInterval, 0, function()

		-- trace into sky to see if outside
		if not self:SkyTrace() then
			if self:GetSkin() != 0 then -- turn off green light if on
				self:SetSkin( 0 )
			end
			return
		end
		
		if self:GetSkin() != 1 then -- check if green light is not on
			self:SetSkin( 1 )
		end
		
		local rand_watts_generated = math.random( CH_Bitminers.Config.SolarPanelWattsMin, CH_Bitminers.Config.SolarPanelWattsMax )
		
		self:SetWattsGenerated( self:GetWattsGenerated() + rand_watts_generated )
		
		-- Update shelf watts
		if IsValid( self.ConnectedEntity ) then
			if IsValid( self.ConnectedEntity.Parent.ConnectedEntity ) then
				local shelf_ent = self.ConnectedEntity.Parent.ConnectedEntity

				if shelf_ent:GetClass() == "ch_bitminer_power_combiner" then
					shelf_ent:SetWattsGenerated( math.Clamp( shelf_ent:GetWattsGenerated() + rand_watts_generated, 0, ( 16 * CH_Bitminers.Config.WattsRequiredPerMiner ) ) )
				else
					shelf_ent:SetWattsGenerated( math.Clamp( self:GetWattsGenerated(), 0, ( 16 * CH_Bitminers.Config.WattsRequiredPerMiner ) ) )
				end
			end
		end
	end )
end

function ENT:DecreaseWatts()
	timer.Create( "bitminer_solar_decreasewatts_".. self:EntIndex(), CH_Bitminers.Config.WattsDecreaseInterval, 0, function()
		if IsValid( self ) then
			local rand_watts_decreased = math.random( CH_Bitminers.Config.DecreaseAmountMin, CH_Bitminers.Config.DecreaseAmountMax )
			
			self:SetWattsGenerated( math.Clamp( self:GetWattsGenerated() - rand_watts_decreased, 0, ( 16 * CH_Bitminers.Config.WattsRequiredPerMiner ) ) )
		end
	end )
end

function ENT:OnTakeDamage( dmg )
	if ( not self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true
		
		self:SetHP( ( self:GetHP() or 100 ) - dmg:GetDamage() )
		if self:GetHP() <= 0 then
			self:Destruct()
			self:Remove()
		end
		
		self.m_bApplyingDamage = false
	end
end

function ENT:SkyTrace()
    local sky = {}
    sky.start = self:GetPos()
    sky.endpos = self:GetPos() + Vector( 0, 0, 100000 )
    sky.filter = self
	
    local tsky = util.TraceLine( sky )
	
    return tsky.HitSky
end

function ENT:Destruct()
	local owner = self.ItemOwner

	if CH_Bitminers.Config.SolarPanelExplosion and not self.IsDestroyed then
		self.IsDestroyed = true
		
		local vPoint = self:GetPos()
		local effect_explode = ents.Create( "env_explosion" )
		if not IsValid( effect_explode ) then return end
		effect_explode:SetPos( vPoint )
		effect_explode:Spawn()
		effect_explode:SetKeyValue( "iMagnitude","75" )
		effect_explode:Fire( "Explode", 0, 0 )
		
		if CH_Bitminers.Config.CreateFireOnExplode then
			local Fire = ents.Create( "fire" )
			Fire:SetPos( vPoint )
			Fire:SetAngles( Angle( 0, 0, 0 ) )
			Fire:Spawn()
		end
	end

	self:Remove()
end

function ENT:OnRemove()
	self:SolarPluggedOut()
	
	-- Remove watt decrease timer
	if timer.Exists( "bitminer_solar_decreasewatts_".. self:EntIndex() ) then
		timer.Remove( "bitminer_solar_decreasewatts_".. self:EntIndex() )
	end
	
	-- Unplug from solar panel if removed
	if IsValid( self.ConnectedEntity ) then
		self.ConnectedEntity:UnplugCable( self )
	end
end