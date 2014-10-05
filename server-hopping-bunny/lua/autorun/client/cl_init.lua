if SERVER then return end
include('sh_shb_config.lua')
include('sh_shb_theme.lua')
include('lib/sh_shb_json.lua')
if SHB.Debug then print("start cl") end

function SHB_Menu(cmd)

	SHB_Window = vgui.Create("DFrame")
	SHB_Window:SetSize(250, 250)
	SHB_Window:SetPos(100, 100)
	SHB_Window:SetTitle("")
	SHB_Window:SetVisible(true)
	SHB_Window:MakePopup()
	SHB_Window:Center()
	SHB_Window:ShowCloseButton(true)
	SHB_Window.Paint = function()
		draw.RoundedBox(0, 0, 0, SHB_Window:GetWide(), SHB_Window:GetTall(), theme.Background)
		draw.RoundedBox(0, 0, 0, SHB_Window:GetWide(), 30, theme.Header)
		draw.SimpleText(SHB.Title, "shbHeader", SHB_Window:GetWide() / 2, 3, theme.Textcolor, TEXT_ALIGN_CENTER);
	end
	addServer(10, 40, 100, 25, 1)
	addServer(10, 80, 100, 25, 2)
	addServer(10, 120, 100, 25, 3)
end
concommand.Add(SHB.OpenCommand, function(ply)
if SHB.Debug then print("concommand cl") end
SHB_Menu() 
PrintTable( SHB_ServerInfo(1) )
end)

function addServer(x, y, w, h, sid)
	local srvip = SHB.IP[sid] .. ":" .. SHB.Port[sid]
	local connectbutton = vgui.Create("DButton", SHB_Window)
	connectbutton:SetText("")
	connectbutton:SetSize(w, h)
	connectbutton:SetPos(x, y)
	connectbutton.Paint = function()
		draw.SimpleText("test", "shbButton", connectbutton:GetWide() / 2, 6, theme.Textcolor, TEXT_ALIGN_CENTER)
	end
	connectbutton.DoClick = function()
		SHB_Window:Close()
		timer.Simple(1, function()
			LocalPlayer():ConCommand("connect " .. srvip)
		end)
	end
end
