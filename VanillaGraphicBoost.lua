-- Vanilla Graphics Boost, Enters the following console commands when the world is loaded.
SlashCmdList["CONSOLE"]("anisotropic 16");
SlashCmdList["CONSOLE"]("baseMip 0");
SlashCmdList["CONSOLE"]("detailDoodadAlpha 100");
--SlashCmdList["CONSOLE"]("DistCull 888");
SlashCmdList["CONSOLE"]("doodadAnim 1");
--SlashCmdList["CONSOLE"]("farclip 777"); -- terrain render distance. Default game value is 777
SlashCmdList["CONSOLE"]("ffx 1");
SlashCmdList["CONSOLE"]("ffxDeath 1");
SlashCmdList["CONSOLE"]("ffxGlow 1");
SlashCmdList["CONSOLE"]("ffxRectangle 1");
SlashCmdList["CONSOLE"]("footstepBias 1.0");
SlashCmdList["CONSOLE"]("frillDensity 256");
SlashCmdList["CONSOLE"]("gxColorBits 24");
SlashCmdList["CONSOLE"]("gxDepthBits 24");
SlashCmdList["CONSOLE"]("horizonfarclip 2112");
SlashCmdList["CONSOLE"]("lod 0");
--SlashCmdList["CONSOLE"]("lodDist 250");
SlashCmdList["CONSOLE"]("mapObjLightLOD 2");
SlashCmdList["CONSOLE"]("mapObjOverbright 1");
SlashCmdList["CONSOLE"]("mapShadows 1");
SlashCmdList["CONSOLE"]("MaxLights 4");
SlashCmdList["CONSOLE"]("maxLOD 3");
SlashCmdList["CONSOLE"]("nearClip 0.33");
SlashCmdList["CONSOLE"]("occlusion 1");
SlashCmdList["CONSOLE"]("particleDensity 1");
SlashCmdList["CONSOLE"]("pixelShaders 1");
SlashCmdList["CONSOLE"]("shadowLevel 0");
SlashCmdList["CONSOLE"]("showfootprints 1");
SlashCmdList["CONSOLE"]("showLowDetail 0");
SlashCmdList["CONSOLE"]("showShadow 1");
SlashCmdList["CONSOLE"]("showSimpleDoodads 0");
SlashCmdList["CONSOLE"]("SkyCloudLOD 1");
SlashCmdList["CONSOLE"]("SkySunGlare 1");
SlashCmdList["CONSOLE"]("SmallCull 0.01");
SlashCmdList["CONSOLE"]("specular 1");
SlashCmdList["CONSOLE"]("spellEffectLevel 2");
SlashCmdList["CONSOLE"]("texLodBias -1");
SlashCmdList["CONSOLE"]("textureLodDist 777");
SlashCmdList["CONSOLE"]("trilinear 1");
SlashCmdList["CONSOLE"]("unitDrawDist 1000");
SlashCmdList["CONSOLE"]("waterLOD 0");
SlashCmdList["CONSOLE"]("waterParticulates 1");
SlashCmdList["CONSOLE"]("waterRipples 1");
SlashCmdList["CONSOLE"]("waterSpecular 1");
SlashCmdList["CONSOLE"]("waterWaves 1");
SlashCmdList["CONSOLE"]("weatherDensity 3");
SlashCmdList["CONSOLE"]("cameraDistanceMax 100");
SlashCmdList["CONSOLE"]("gxMultisample 8");
SlashCmdList["CONSOLE"]("gxMultisampleQuality 1");
SlashCmdList["CONSOLE"]("showCull");

local function IsSuperWoWLoaded()
	-- https://github.com/balakethelock/SuperWoW/wiki/Features
	return type(SetAutoloot) ~= "nil" and type(Clickthrough) ~= "nil"
end

	--print("Is SuperWoW loaded: " .. (IsSuperWoWLoaded() and "Yes" or "No"))

if IsSuperWoWLoaded() then
	SlashCmdList["CONSOLE"]("FoV 1.925"); -- set camera field of view (default = "1.57", can be any value from "0.1" to "3.14")
	SlashCmdList["CONSOLE"]("SelectionCircleStyle 3"); -- set a different appearance for the target circle. https://github.com/balakethelock/SuperWoW/wiki/Changelog#14042024--110
	SlashCmdList["CONSOLE"]("BackgroundSound 1"); -- set to enable or disable background sound while tabbed out (default = "0", can be "0" or "1")
	SlashCmdList["CONSOLE"]("UncapSounds 1"); -- set to "1" to remove the hardcoded soundchannels limit.
	SlashCmdList["CONSOLE"]("SoundSoftwareChannels 64"); -- If you want true uncapped sound experience you still have accompany this CVAR
	SlashCmdList["CONSOLE"]("SoundMaxHardwareChannels 64"); -- If you want true uncapped sound experience you still have accompany this CVAR
end

	-- https://github.com/GryllsAddons/ShaguTweaks-mods/blob/main/mods/max-graphics.lua
	-- https://docs.google.com/spreadsheets/d/17bXs9WhOkP8Zknl1GYXCFVdHYOdgxoRFrIe7Os3BtRo/edit#gid=0
	local graphics = CreateFrame("Frame", nil, UIParent)

	function graphics:performance()
		SlashCmdList["CONSOLE"]("DistCull 500") -- 500 / 888
		SlashCmdList["CONSOLE"]("farclip 500") -- 500 / 777
		SlashCmdList["CONSOLE"]("lodDist 100") -- 100 / 250
	end

	function graphics:quality()
		SlashCmdList["CONSOLE"]("DistCull 888") -- 500 / 888
		SlashCmdList["CONSOLE"]("farclip 777") -- 500 / 777
		SlashCmdList["CONSOLE"]("lodDist 250") -- 100 / 250
	end

	function graphics:mapUpdate()
		local zone = GetRealZoneText()
		if graphics.zone ~= zone then
			graphics.zone = zone
			if IsInInstance() then
				graphics:performance()
			else
				graphics:quality()
			end
		end
	end

	graphics:RegisterEvent("PLAYER_ENTERING_WORLD")
	graphics:RegisterEvent("MINIMAP_ZONE_CHANGED")
	graphics:SetScript("OnEvent", function()
		if event == "MINIMAP_ZONE_CHANGED" then
			graphics:mapUpdate()
		end
	end)
