-- "addons\\cosmic\\lua\\dash\\extensions\\color.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local tonumber 		= tonumber
local string_format = string.format
local string_match 	= string.match
local bit_band		= bit.band
local bit_rshift 	= bit.rshift
local Lerp 			= Lerp

local COLOR = FindMetaTable 'Color'

function Color(r, g, b, a)
	return setmetatable({
		r = tonumber(r) or 255,
		g = tonumber(g) or 255,
		b = tonumber(b) or 255,
		a = tonumber(a) or 255
	}, COLOR)
end

function COLOR:Glow(color, factor)
	local r = self.r + ((color.r - self.r) * factor)
	local g = self.g + ((color.g - self.g) * factor)
	local b = self.b + ((color.b - self.b) * factor)

	return Color(r, g, b)
end

function COLOR:Offset(offset)
	assert(self, 'missing color')

	offset = offset or 0

	local r = math.Clamp(self.r + offset, 0, 255)
	local g = math.Clamp(self.g + offset, 0, 255)
	local b = math.Clamp(self.b + offset, 0, 255)

	return Color(r, g, b)
end

function COLOR:Opacity(opacity)
	assert(self, 'missing color')

	opacity = opacity or 255

	return Color(self.r, self.g, self.b, opacity)
end

function COLOR:OpacityOffset(opacity, offset)
	assert(self, 'missing color')
	opacity = opacity or 255
	offset = offset or 0

	local r = math.Clamp(self.r + offset, 0, 255)
	local g = math.Clamp(self.g + offset, 0, 255)
	local b = math.Clamp(self.b + offset, 0, 255)

	return Color(r, g, b, opacity)
end

function COLOR:Between(colr, fraction)
	fraction = fraction or .5

	local r = Lerp(fraction, self.r, colr.r)
	local g = Lerp(fraction, self.g, colr.g)
	local b = Lerp(fraction, self.b, colr.b)

	return Color(r, g, b)
end

function COLOR:Copy()
	return Color(self.r, self.g, self.b, self.a)
end

function COLOR:Unpack()
	return self.r, self.g, self.b, self.a
end

function COLOR:SetHex(hex)
	local r, g, b = string_match(hex, '#(..)(..)(..)')
	self.r, self.g, self.b = tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
end

function COLOR:ToHex()
	return string_format('#%02X%02X%02X', self.r, self.g, self.b)
end

function COLOR:SetEncodedRGB(num)
	self.r, self.g, self.b = bit_band(bit_rshift(num, 16), 0xFF), bit_band(bit_rshift(num, 8), 0xFF), bit_band(num, 0xFF)
end

function COLOR:ToEncodedRGB()
	return (self.r * 0x100 + self.g) * 0x100 + self.b
end

function COLOR:SetEncodedRGBA(num)
	self.r, self.g, self.b, self.a = bit_band(bit_rshift(num, 16), 0xFF), bit_band(bit_rshift(num, 8), 0xFF), bit_band(num, 0xFF), bit_band(bit_rshift(num, 24), 0xFF)
end

function COLOR:ToEncodedRGBA()
	return ((self.a * 0x100 + self.r) * 0x100 + self.g) * 0x100 + self.b
end

function COLOR:LerpTo(fraction, to)
	local r = Lerp(fraction, self.r, to.r)
	local g = Lerp(fraction, self.g, to.g)
	local b = Lerp(fraction, self.b, to.b)
	local a = Lerp(fraction, self.a, to.a)

	return Color(r, g, b, a)
end

function COLOR:EditHSV(hue, saturation, value)
	local h, s, v = ColorToHSV(self)
	return HSVToColor(hue or h, saturation or s, value or v)
end

function COLOR:IsLight()
	local _, _, l = ColorToHSL(self)
	return l >= .5
end

function COLOR:InverseLight(color, snap)
	color = color or color_white
	local _, _, l = ColorToHSL(self)
	local h, s, _ = ColorToHSL(color)

	return HSLToColor(h, s, snap and math.Round(1 - l) or (1 - l))
end

function COLOR:Lerp(fraction, from, to)
	if type(from) ~= "table" or type(to) ~= "table" then return end
	self.r = Lerp(fraction, from.r, to.r)
	self.g = Lerp(fraction, from.g, to.g)
	self.b = Lerp(fraction, from.b, to.b)
	self.a = Lerp(fraction, from.a or 255, to.a or 255)
end

function COLOR:LerpFromTo(k, l, m)
    self.r, self.g, self.b = Lerp(k, l.r, m.r), Lerp(k, l.g, m.g), Lerp(k, l.b, m.b)
end