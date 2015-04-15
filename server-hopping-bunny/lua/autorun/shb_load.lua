SHB = {}

if SERVER then
	AddCSLuaFile("shb/cl_init.lua")
	AddCSLuaFile("shb/cl_themes.lua")
	AddCSLuaFile("shb/config.lua")
else
	include("shb/cl_init.lua")
end
