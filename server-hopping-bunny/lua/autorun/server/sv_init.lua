--[[
Exho the Server Hopping Bunny
made by Tomelyr for Exho and the FP Community
Shameless Copy Paste of RHUD and some Snippets all over Facepunch
because i can't code. Wait a sec... Why i'm still here?
Love you all <3 :P
--]]

if (not SERVER) then return end
--[[ Client Side Files ]]--
AddCSLuaFile('sh_shb_config.lua')
AddCSLuaFile('sh_shb_theme.lua')
AddCSLuaFile('lib/sh_shb_json.lua')
AddCSLuaFile('lib/sh_colors.lua')
--[[ Includes ]]--
include('sh_shb_config.lua')

--[[ Open the Window (shameless copy paste from RHUD ]]--
function openSHB(ply, text)
	if SHB.Debug then print("Open Command") end
	if text:lower():find( "^[/!]server[s]?$" ) then
		ply:ConCommand(SHB.OpenCommand)
		if SHB.Debug then print("After Check (now concommand) ") end
	end
end

hook.Add("PlayerSay", "openSHB", openSHB)


