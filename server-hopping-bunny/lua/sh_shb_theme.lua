--[[ Includes ]]--
include('sh_shb_config.lua')
include('lib/sh_colors.lua')
--[[ Precaching the Colors and array ]]--
local color = GetColors()
theme = {}
	--[[ Fonts ]]--
if SHB.FontSet == "coolvetica" then
	surface.CreateFont("shbHeader", {font="coolvetica", size=24, weight=500})
	surface.CreateFont("shbButton", {font="coolvetica", size=24, weight=250})
end

	--[[ Colors ]]--
if SHB.Theme == "default" then

	theme.Header = color["grey72"]
	theme.Background = color["grey42"]
	theme.Textcolor = color["antique white"]
	theme.PanelBG = color["grey80"]
	theme.PanelButton = color["grey42"]
end
