	-- Vanilla Graphics Boost, Enters the following console commands when the world is loaded.
	ConsoleExec("anisotropic 16")
	ConsoleExec("baseMip 0")
	ConsoleExec("detailDoodadAlpha 100")
	--ConsoleExec("DistCull 888")
	ConsoleExec("doodadAnim 1")
	--ConsoleExec("farclip 777") -- terrain render distance. Default game value is 777
	ConsoleExec("ffx 1")
	ConsoleExec("ffxDeath 1")
	ConsoleExec("ffxGlow 1")
	ConsoleExec("ffxRectangle 1")
	ConsoleExec("footstepBias 1.0")
	ConsoleExec("frillDensity 256")
	ConsoleExec("gxColorBits 24")
	ConsoleExec("gxDepthBits 24")
	ConsoleExec("horizonfarclip 2112")
	ConsoleExec("lod 0")
	--ConsoleExec("lodDist 250")
	ConsoleExec("mapObjLightLOD 2")
	ConsoleExec("mapObjOverbright 1")
	ConsoleExec("mapShadows 1")
	ConsoleExec("MaxLights 4")
	ConsoleExec("maxLOD 3")
	ConsoleExec("nearClip 0.33")
	ConsoleExec("occlusion 1")
	ConsoleExec("particleDensity 1")
	ConsoleExec("pixelShaders 1")
	ConsoleExec("shadowLevel 0")
	ConsoleExec("showfootprints 1")
	ConsoleExec("showLowDetail 0")
	ConsoleExec("showShadow 1")
	ConsoleExec("showSimpleDoodads 0")
	ConsoleExec("SkyCloudLOD 1")
	ConsoleExec("SkySunGlare 1")
	ConsoleExec("SmallCull 0.01")
	ConsoleExec("specular 1")
	ConsoleExec("spellEffectLevel 2")
	ConsoleExec("texLodBias -1")
	ConsoleExec("textureLodDist 777")
	ConsoleExec("trilinear 1")
	ConsoleExec("unitDrawDist 1000")
	ConsoleExec("waterLOD 0")
	ConsoleExec("waterParticulates 1")
	ConsoleExec("waterRipples 1")
	ConsoleExec("waterSpecular 1")
	ConsoleExec("waterWaves 1")
	ConsoleExec("weatherDensity 3")
	ConsoleExec("cameraDistanceMax 100")
	ConsoleExec("gxMultisample 8")
	ConsoleExec("gxMultisampleQuality 1")
	ConsoleExec("showCull")

--[[ Extra parameters
	ConsoleExec("bspcache 1")
	ConsoleExec("M2UsePixelShaders 1")
	ConsoleExec("M2UseZFill 1")
	ConsoleExec("M2UseClipPlanes 1")
	ConsoleExec("M2UseThreads 1")
	ConsoleExec("M2UseShaders 1")
	ConsoleExec("M2BatchDoodads 1")
	ConsoleExec("M2Faster 3") -- <CPU physical cores - 1> (Dual-core = 1, Tri-core = 2, Quad-core and above = 3)

	ConsoleExec("gxFixLag 1") -- fixes mouse lag at expense of frames per second.
	ConsoleExec("timingModeOverride 2") -- 1 (uses GetTickCount) 2 (uses RDTSC) 3 (uses QueryPerformanceCounter) 4 (uses timeGetTime). Experiment with which timing method gives you the smoothest gameplay. Set the value, then restart the game completely. Apparently RDTSC is the most precise timing method.

	-- ConsoleExec("gxRefresh 60") <your monitor's maximum refresh rate> e.g. gxRefresh 60 (for 60hz monitor)
	-- ConsoleExec("gxTripleBuffer 1")
	-- ConsoleExec("gxVSync 1")
--]]

--[[ Addons parameters for comparison with each other
	--ShaguTweaks conf
	ConsoleExec("frillDensity 64")
	ConsoleExec("unitDrawDist 300")

	--PFUI conf
	ConsoleExec("frillDensity 24") -- 48 (slider value), 15 (slider value)
	ConsoleExec("lodDist 100") -- 100+arg*10 (slider value)
	ConsoleExec("nearClip 0.1") -- arg*2/100 (slider value)
	ConsoleExec("maxLOD 0") -- arg (slider value)
	ConsoleExec("footstepBias 0.125") -- arg/15 (slider value)
	ConsoleExec("DistCull 500") -- 500+arg*25.92 (slider value)
	ConsoleExec("SkyCloudLOD 0") -- 1 (slider value)
	ConsoleExec("mapObjLightLOD 0") -- 2 (slider value)
	ConsoleExec("texLodBias 0") -- -1 (slider value)
--]]

local DEBUG_MODE = false

local function DebugPrint(message)
	if DEBUG_MODE then
		DEFAULT_CHAT_FRAME:AddMessage("Debug: " .. message)
	end
end

local function IsSuperWoWLoaded()
	-- https://github.com/balakethelock/SuperWoW/wiki/Features
	return type(SetAutoloot) ~= "nil" and type(Clickthrough) ~= "nil"
end

	DebugPrint("SuperWoW loaded: " .. (IsSuperWoWLoaded() and "Yes" or "No"))

if IsSuperWoWLoaded() then
	--https://github.com/fosley/WowFovChanger/blob/master/WowFovChanger/WowFovChanger.dat
	--https://github.com/Quinchilion/WoWFoVFix/blob/master/src/WoWFoVFix/WoWFoVFix.cpp
local function CalculateFoV(screenWidth, screenHeight)
	local DEGREES_TO_RADIANS = math.pi / 180
	local RADIANS_TO_DEGREES = 180 / math.pi

	-- Base FoV value for a 4:3 screen ratio
	local BASE_FIELD_OF_VIEW = 90 * DEGREES_TO_RADIANS
	local BASE_SCREEN_RATIO = 4.0 / 3.0
	local BASE_VIEW_DISTANCE = BASE_SCREEN_RATIO / math.tan(BASE_FIELD_OF_VIEW / 2)

	local MAX_FIELD_OF_VIEW = 170 * DEGREES_TO_RADIANS
	local MIN_FIELD_OF_VIEW = 30 * DEGREES_TO_RADIANS

	if screenWidth == 0 or screenHeight == 0 then
		DebugPrint("Screen size is zero, using default FoV")
		return BASE_FIELD_OF_VIEW
	end

	local screenRatio = screenWidth / screenHeight
	local newFoV = 2 * math.atan(screenRatio / BASE_VIEW_DISTANCE)
	newFoV = math.max(math.min(newFoV, MAX_FIELD_OF_VIEW), MIN_FIELD_OF_VIEW)

	DebugPrint("Calculated FoV (Degrees): " .. newFoV * RADIANS_TO_DEGREES)
	return newFoV
end

local function ApplyFoV()
	local resolution = GetCVar("gxResolution")
	local xIndex = string.find(resolution, "x")
	local screenWidth, screenHeight = tonumber(string.sub(resolution, 1, xIndex - 1)), tonumber(string.sub(resolution, xIndex + 1))
	--local screenWidth, screenHeight = GetScreenWidth(), GetScreenHeight()
	DebugPrint("Screen size: " .. screenWidth .. "x" .. screenHeight)
	local optimalFoV = CalculateFoV(screenWidth, screenHeight)
	--ConsoleExec("FoV ".. optimalFoV)
	SetCVar("FoV", optimalFoV)
	DebugPrint("Applied FoV: " .. optimalFoV)
end

-- Функция для проверки изменения разрешения экрана
local function CheckForResolutionChange()
	local currentResolution = GetCVar("gxResolution")
	if currentResolution ~= previousResolution then
		DebugPrint("Resolution change detected")
		ApplyFoV()
		previousResolution = currentResolution
	end
end

-- Инициализация переменной для хранения предыдущего разрешения
local previousResolution = GetCVar("gxResolution")
DebugPrint("Initial resolution: " .. previousResolution)

-- Создание таймера для проверки изменения разрешения каждые 5 секунд
local frame = CreateFrame("Frame")
local function OnUpdate()
	CheckForResolutionChange()
end
frame:SetScript("OnUpdate", OnUpdate)
frame:Show()
DebugPrint("Timer started")

--[[
-- Получение текущего разрешения экрана и масштаба интерфейса
local resolution = GetCVar("gxResolution")
local scale = GetCVar("uiScale")

-- Извлечение ширины и высоты из строки разрешения
local xIndex = string.find(resolution, "x")
local width, height = tonumber(string.sub(resolution, 1, xIndex - 1)), tonumber(string.sub(resolution, xIndex + 1))

-- Aspect ratio
local aspectRatio = width / height

-- Угол обзора в градусах
local fovHorizontal = 64.40
-- Коэффициент преобразования FOV для Vanilla 1.12.1
local fovRatio = 41

-- Calculate horizontal field of view (fov) in degrees based on aspect ratio
--local fovVerticalCalc = 2 * math.atan(height / (width * 2 * math.tan(math.rad(fovHorizontal / 2)))) * (180 / math.pi)
--local fovHorizontalCalc = 2 * math.atan(width / (height * 2 * math.tan(math.rad(fovVerticalCalc / 2)))) * (180 / math.pi)

local fovHorizontalCalc = 2 * math.atan(width / (2 * height)) * (180 / math.pi)

-- Расчет соотношения FOV
local fovRatioManual = fovHorizontal / fovRatio
local fovRatioCalc = fovHorizontalCalc / fovRatio

--local clampedfovWan = math.min(fovWan, math.pi) -- максимальное значение

DebugPrint("Aspect Ratio: " .. aspectRatio)
DebugPrint("FOV Degrees Calculated: " .. fovHorizontalCalc)
DebugPrint("FOV Degrees Manual: " .. fovHorizontal)
DebugPrint("FOV Ratio Calculated: " .. fovRatioCalc)
DebugPrint("FOV Ratio Manual: " .. fovRatioManual)
--]]

	--ConsoleExec("FoV 1.925") -- set camera field of view (default = "1.57", can be any value from "0.1" to "3.14")
	ConsoleExec("SelectionCircleStyle 3") -- set a different appearance for the target circle. https://github.com/balakethelock/SuperWoW/wiki/Changelog#14042024--110
	ConsoleExec("BackgroundSound 1") -- set to enable or disable background sound while tabbed out (default = "0", can be "0" or "1")
	ConsoleExec("UncapSounds 1") -- set to "1" to remove the hardcoded soundchannels limit.
	ConsoleExec("SoundSoftwareChannels 64") -- If you want true uncapped sound experience you still have accompany this CVAR
	ConsoleExec("SoundMaxHardwareChannels 64") -- If you want true uncapped sound experience you still have accompany this CVAR
end

	-- https://github.com/GryllsAddons/ShaguTweaks-mods/blob/main/mods/max-graphics.lua
	-- https://docs.google.com/spreadsheets/d/17bXs9WhOkP8Zknl1GYXCFVdHYOdgxoRFrIe7Os3BtRo/edit#gid=0
	local graphics = CreateFrame("Frame", nil, UIParent)

	function graphics:performance()
		ConsoleExec("DistCull 500") -- 500 / 888
		ConsoleExec("farclip 500") -- 500 / 777
		ConsoleExec("lodDist 100") -- 100 / 250
	end

	function graphics:quality()
		ConsoleExec("DistCull 888") -- 500 / 888
		ConsoleExec("farclip 777") -- 500 / 777
		ConsoleExec("lodDist 250") -- 100 / 250
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
