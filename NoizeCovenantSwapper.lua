-- covenant class abilities
local covenantSpells = {
					   --   1   |   2   |    3    |    4
					   -- Kyrian|Venthyr|Night Fae|Necrolord
						 {307865, 317349, 325886, 324143}, -- Warrior (1)
						 {304971, 316958, 328278, 328204}, -- Paladin (2)
						 {308491, 324149, 328231, 325028}, -- Hunter (3)
						 {323547, 323654, 328305, 328547}, -- Rogue (4)
						 {325013, 323673, 327661, 324724}, -- Priest (5)
						 {312202, 311648, 324128, 315443}, -- Death Knight (6)
						 {324386, 320674, 328923, 326059}, -- Shaman (7)
						 {307443, 314793, 314791, 324220}, -- Mage (8)
						 {321321, 321792, 325640, 325289}, -- Warlock (9)
						 {310454, 326860, 327104, 325216}, -- Monk (10)
						 {326434, 323546, 323764, 325727}, -- Druid (11)
						 {306830, 317009, 323639, 329554}  -- Demon Hunter (12)
}				
local signatureSpells = {324739, 300728, 310143, 324631}

local abilityMacroName = "CovAbility"
local signatureMacroName = "CovSignature"

local kyrian = "#showtooltip item:177278\n/cast [mod:alt] "..GetSpellInfo(signatureSpells[1]).."\n/cast [nomod] item:177278"
local venthyr = "#showtooltip\n/cast [mod:alt][@cursor] "..GetSpellInfo(signatureSpells[2])
local nightFae = "#showtooltip\n/cast "..GetSpellInfo(signatureSpells[3])
local necrolord = "#showtooltip\n/cast "..GetSpellInfo(signatureSpells[4])

local signatureMacroArray = {kyrian, venthyr, nightFae, necrolord}

local ADDON_CHAT_TITLE = "|CFF277EA3Noize Covenant Swapper:|r"

local frame = CreateFrame("FRAME")

frame:RegisterEvent("COVENANT_CHOSEN")
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function()
			
	local abilityMacro = GetMacroInfo(abilityMacroName)
	local signatureMacro = GetMacroInfo(signatureMacroName)
		
	if InCombatLockdown() then
		print("%sWARNING: Could not edit macros because you were in combat lockdown", ADDON_CHAT_TITLE)
	end
	
	if not InCombatLockdown() then
		local covenantID = C_Covenants.GetActiveCovenantID()
		local _,_,classIdx = UnitClass("player")
		local spellId = covenantSpells[classIdx][covenantID]
		local spellName = GetSpellInfo(spellId)
		local mouseover = ""
		local cursor = ""
		
		-- set mouseover string for following abilites:  The Hunt, Sinful Brand, Serrated Bone Spike, 
		if spellId == 317009 or spellId == 323639 or spellId == 328547 then
			mouseover = "[@mouseover,exists][] "
		end
		
		-- set cursor string for following abilites: Spear of Bastion, Elysian Decree, Bonedust Brew
		if spellId == 307865 or spellId == 306830 or spellId == 325216 then
			cursor = "[mod:alt][@cursor] "
		end
			
		-- edit abilityMacro
		if abilityMacro then
			EditMacro(abilityMacroName, nil, nil, "#showtooltip\n/cast "..mouseover..cursor..spellName)
			print(string.format("%s Ability Macro changed.",ADDON_CHAT_TITLE));
		end
		-- create abilityMacro (not existing)
		if not abilityMacro then
			CreateMacro(abilityMacroName, "INV_MISC_QUESTIONMARK", "#showtooltip\n/cast "..mouseover..cursor..spellName, nil)
			print(string.format("%s Ability Macro created.",ADDON_CHAT_TITLE));
		end
		
		-- edit signatureMacro
		if signatureMacro then
			EditMacro(signatureMacroName, nil, nil, signatureMacroArray[covenantID])
			print(string.format("%s Signature Macro changed.",ADDON_CHAT_TITLE));
		end
		-- create signatureMacro
		if not signatureMacro then
			CreateMacro(signatureMacroName, "INV_MISC_QUESTIONMARK", signatureMacroArray[covenantID], nil)
			print(string.format("%s Signature Macro created.",ADDON_CHAT_TITLE));
		end
	end

end)
