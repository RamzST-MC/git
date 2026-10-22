-- ВАЖНО: в базе игроков хранится НОМЕР ранга (второй аргумент Create), а не имя.
-- Поэтому номера 1-14 оставлены как были: игроки сохраняют ранг, меняется только имя/права.
-- Имена в нижнем регистре и без пробелов - это то, что возвращает pl:GetRank().
--
--  Раньше (номер)       ->  Теперь
--  1  User                  user
--  2  VIP                   vip
--  3  dmoderator            dmoder
--  4  dadmin                dadmin
--  5  sadmind               dsuperadmin
--  6  helper                helper
--  7  moderator             moder
--  8  admin                 admin
--  9  stadmin               superadmin
--  10 sponsor               downer
--  11 Operator              owner
--  12 Sudo Root             subcurator
--  13 curator               curator
--  14 Root                  root
--  новые: 15 dvip, 16 probation, 17 naboradmin

-- Обычные ----------------------------------------------------------------
ba.ranks.Create('user', 1)
	:SetImmunity(0)
	:SetFlags('u')

ba.ranks.Create('vip', 2)
	:SetImmunity(1000)
	:SetFlags('uv')
	:SetVIP(true)

ba.ranks.Create('moder', 7)
	:SetImmunity(5500)
	:SetFlags('uvmasqkphl')
	:SetAdmin(true)
	:SetMaxBan( 7 * 86400, "7d" )

ba.ranks.Create('admin', 8)
	:SetImmunity(6000)
	:SetFlags('uvmasqkphlo')
	:SetAdmin(true)
	:SetMaxBan( 30 * 86400, "30d" )

ba.ranks.Create('superadmin', 9)
	:SetImmunity(7000)
	:SetFlags('uvmasqkphlo')
	:SetAdmin(true)

ba.ranks.Create('owner', 11)
	:SetImmunity(13000)
	:SetFlags('uvmasoqkpwhdl')
	:SetSuperAdmin(true)

-- Донатные (d) -----------------------------------------------------------
ba.ranks.Create('dvip', 15)
	:SetImmunity(1500)
	:SetFlags('uv')
	:SetVIP(true)

ba.ranks.Create('dmoder', 3)
	:SetImmunity(2000)
	:SetFlags('uvmp')
	:SetAdmin(true)
	:SetMaxBan( 1 * 3600, "1h" )

ba.ranks.Create('dadmin', 4)
	:SetImmunity(3000)
	:SetFlags('uvmap')
	:SetAdmin(true)
	:SetMaxBan( 1 * 86400, "1d" )

ba.ranks.Create('dsuperadmin', 5)
	:SetImmunity(4000)
	:SetFlags('uvmap')
	:SetAdmin(true)
	:SetMaxBan( 3 * 86400, "3d" )

ba.ranks.Create('downer', 10)
	:SetImmunity(4500)
	:SetFlags('uvmasqkpl')
	:SetAdmin(true)
	:SetMaxBan( 30 * 86400, "1mo" )

-- Набор ------------------------------------------------------------------
ba.ranks.Create('probation', 16)
	:SetImmunity(4800)
	:SetFlags('uvmp')
	:SetAdmin(true)
	:SetMaxBan( 1 * 3600, "1h" )

ba.ranks.Create('helper', 6)
	:SetImmunity(5000)
	:SetFlags('uvmasqkplh')
	:SetAdmin(true)
	:SetMaxBan( 30 * 86400, "1mo" )

ba.ranks.Create('naboradmin', 17)
	:SetImmunity(5200)
	:SetFlags('uvmasqkplh')
	:SetAdmin(true)
	:SetMaxBan( 30 * 86400, "1mo" )

-- Кураторы ---------------------------------------------------------------
ba.ranks.Create('subcurator', 12)
	:SetImmunity(14000)
	:SetFlags('uvmasoqkpwhdl')
	:SetSuperAdmin(true)

ba.ranks.Create('curator', 13)
	:SetImmunity(15000)
	:SetFlags('uvmasoqkpwhdlr')
	:SetSuperAdmin(true)

ba.ranks.Create('root', 14)
	:SetImmunity(16000)
	:SetRoot(true)