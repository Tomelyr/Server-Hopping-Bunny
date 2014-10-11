if SERVER then return end
include('sh_shb_config.lua')
include('sh_shb_theme.lua')
include('lib/sh_shb_json.lua')
if SHB.Debug then print("start cl") end

local srvcount = table.Count(SHB.IP)
local pgc = math.ceil(srvcount/3)
function SHB_Menu(cmd)
	local tall = 75
	local spacing = 30
	local tallcount = 0
	
	for i=1, 3 do
		tall = tall + spacing + 80
	end
	SHB_Window = vgui.Create("DFrame")
	SHB_Window:SetSize(600, 420)
	SHB_Window:SetPos(100, 100)
	SHB_Window:SetTitle("")
	SHB_Window:SetVisible(true)
	SHB_Window:MakePopup()
	SHB_Window:Center()
	SHB_Window:ShowCloseButton(false)
	SHB_Window:SizeToContents()
	SHB_Window.Paint = function()
        draw.RoundedBox( 0, 0, 0, SHB_Window:GetWide(), SHB_Window:GetTall(), Color(52, 73, 94, 255) )
        draw.RoundedBox( 0, 0, 0, SHB_Window:GetWide(), 25, Color(44, 62, 80,255) )
	end
	local ExitButton = vgui.Create( "DButton", SHB_Window )
    ExitButton:SetText( "X" )
    ExitButton:SetTextColor( Color(255,255,255,255) )
    ExitButton:SetPos( SHB_Window:GetWide() - 45, 2 )
    ExitButton:SetSize( 40, 20 )
    ExitButton.Paint = function()
        draw.RoundedBox( 0, 0, 0, ExitButton:GetWide(), ExitButton:GetTall(), Color(200, 79, 79,255) )
    end
    ExitButton.DoClick = function()
        SHB_Window:Close()
    end
	Mother(1)
	local PanelLabel = vgui.Create("DLabel", SHB_Window) -- My own title because I wanted to use my own font
    PanelLabel:SetPos(10, 5)
    PanelLabel:SetSize(30, SHB_Window:GetWide())
    PanelLabel:SetColor(Color(255,255,255))
    PanelLabel:SetFont("shbHeader")
    PanelLabel:SetText("Server Hopper")
    PanelLabel:SizeToContents()
	local x = 60
	for i=1, 3 do
		headeroffset = 20
		xoffset = 100
		if SHB.IP[i] != nil then addServer(x, i) end
		x = x + xoffset
	end
end

concommand.Add(SHB.OpenCommand, function(ply)
if SHB.Debug then print("concommand cl") end
SHB_Menu() 
end)

function addServer(x, sid)
	local srvip = SHB.IP[sid] .. ":" .. SHB.Port[sid]
	local server = {}
	local mapurl = "https://raw.githubusercontent.com/Svenskunganka/OpenLoad/master/templates/strapquery/img/unknown_map.jpg"
	GetServerInfo(sid, function(call)
	server = call 
	if call["mapurl"] then
	mapurl = "http://image.www.gametracker.com/images/maps/160x120/garrysmod/" .. call["map"] .. ".jpg"
	end
	end)
	local Panel = vgui.Create( "DPanel", PanelTest )
	Panel:SetSize(520, 80)
	Panel:SetPos(40, 100)
	Panel:AlignTop(x)
	Panel.Paint = function()
		if server["name"] != nil then
		 draw.RoundedBox( 0, 0, 0, Panel:GetWide(), Panel:GetTall(), theme.PanelBG )
		else
		 draw.RoundedBox( 0, 0, 0, Panel:GetWide(), Panel:GetTall(), Color(155,0,0) )
		end
	end
	local hostnamebutton = vgui.Create("DLabel", Panel)
	hostnamebutton:SetText("")
	hostnamebutton:SetSize(550, 75)
	hostnamebutton:SetPos(0, 10)
	hostnamebutton.Paint = function()
	if server["name"] != nil then
		draw.SimpleText(server["name"], "shbButton", hostnamebutton:GetWide() / 2, 0, Color(0,0,0), TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("Offline", "shbButton", hostnamebutton:GetWide() / 2, 0, Color(0,0,0), TEXT_ALIGN_CENTER)
	end
	end
	local imghtml = vgui.Create("HTML", Panel)
	imghtml:SetPos(0,0)
	imghtml:SetSize(100,100)
	local playcount = vgui.Create("DLabel", Panel)
	playcount:SetText("")
	playcount:SetSize(550, 75)
	playcount:SetPos(0, Panel:GetTall()/2)
	playcount.Paint = function()
	if server["name"] != nil then
		draw.SimpleText(server["players"] .. " / " .. server["maxplayers"] .. " Players on ".. server["map"], "shbButton", 80, 0, Color(0,0,0), TEXT_ALIGN_LEFT)
	end
	end
	local connectbutton = vgui.Create("DButton", Panel)
	connectbutton:SetText("")
	connectbutton:SetSize(75, 30)
	connectbutton:SetPos(425, Panel:GetTall()/2)
	connectbutton.Paint = function()
	if server["name"] != nil then
		draw.RoundedBox(4, 0, 0, connectbutton:GetWide(), connectbutton:GetTall(), theme.PanelButton)
		draw.SimpleText("Connect", "shbButton", connectbutton:GetWide() / 2, 6, Color(0,0,0), TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("Connect", "shbButton", connectbutton:GetWide() / 2, 6, Color(255,0,0), TEXT_ALIGN_CENTER)
	end
	end
	connectbutton.DoClick = function()
	if server["name"] !=nil then
		SHB_Window:Close()
		timer.Simple(1, function()
			LocalPlayer():ConCommand("connect " .. srvip)
		end)
	end
	end
	timer.Simple(0.75, function() if IsValid(imghtml) then imghtml:SetHTML("<img width='63px' height='63px' src='"..mapurl.."'>") end end)
end

function Mother(page)
	local index = page * 3 + 1
	PanelTest = vgui.Create("DPanel", SHB_Window)
	PanelTest:SetSize(600, 520)
	PanelTest:SetPos(0, 25)
	PanelTest.Paint = function()
		draw.RoundedBox( 0, 0, 0, PanelTest:GetWide(), 0, Color(44, 62, 80,255) )
	end
	if page != 1 then PageButton("back",page-1) end
	if SHB.IP[index] != nil then PageButton("forward",page+1) end
end

function PageButton(dir, nextpage)
	local server3 = nextpage * 3
	local server1 = server3 - 2
	local name = ""
	local pos = 0
	if dir == "back" then name = "<" pos = 220 end
	if dir == "forward" then name = ">" pos = 305 end
	PageBack = vgui.Create("DButton", PanelTest)
	PageBack:SetText("")
	PageBack:SetSize(75, 30)
	PageBack:SetPos(pos, 10)
	PageBack.Paint = function()
		--draw.RoundedBox(0, 0, 0, PageBack:GetWide(), PageBack:GetTall(), theme.PanelButton)
		draw.SimpleText(name, "shbPageButton", PageBack:GetWide() / 2, 0, Color(0,0,0), TEXT_ALIGN_CENTER)
	end
	PageBack.DoClick = function()
		PanelTest:Remove()
		Mother(nextpage)
		local x = 60
		for i=server1, server3 do
			xoffset = 100
				if SHB.IP[i] != nil then addServer(x, i) end
			x = x + xoffset
		end
	end
end
	