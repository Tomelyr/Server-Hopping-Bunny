SHB.Servers = {}

function SHB.AddServer(ip, port)
	SHB.Servers[#SHB.Servers + 1] = {ip=ip, port=port}
end

local function checkerror(code)
	if code == 500 then
		error("Server-Hopping-Bunny: Error fetching data. Is cURL installed on your webserver and is your config correct?")
	elseif code == 404 then
		error("Server-Hopping-Bunny: API not found. Is it uploaded to your webserver and is your config correct?")
	end
end

function SHB.GetServerInfo(id, callback)
	local srv = SHB.Servers[id]
	http.Fetch(SHB.ScriptURL .. "/shb_api.php?ip=" .. srv.ip .. "&port=" .. srv.port,
		function(body, len, headers, code)
			checkerror(code)
			callback(util.JSONToTable(body))
		end,
		function(err)
			error("Server-Hopping-Bunny: Error fetching server info with GetServerInfo: "..err)
		end
	)
end

include("shb/cl_themes.lua")
include("shb/config.lua")

surface.CreateFont("SHB_Header", {font="coolvetica", size=24, weight=500})
surface.CreateFont("SHB_Text", {font="coolvetica", size=24, weight=250})
surface.CreateFont("SHB_PageButton", {font="coolvetica", size=48, weight=500})

local servercount = #SHB.Servers
local pagecount = math.ceil(servercount/3)
local serversonpage = math.min(servercount, 3) -- cap at 3
local currentpage = 1

local color_red = Color(155, 0, 0)

local function ServerPanel(container, id)
	currentpage = 1
	local srvip = SHB.Servers[id].ip .. ":" .. SHB.Servers[id].port
	local theme = SHB.GetThemeColors(SHB.Theme)

	local main = vgui.Create("DPanel", container)
	main:SetSize(520, 80)
	main:DockPadding(0, 4, 0, 0)
	main.Paint = function(self, w, h)
		surface.SetDrawColor(theme.ServerPanelBG)
		surface.DrawRect(0, 0, w, h)
	end

	local imghtml = vgui.Create("HTML", main)
	imghtml:SetSize(100, 100)
	imghtml:Dock(LEFT)
	imghtml:SetHTML("<img width='80px' height='60px' src='https://raw.githubusercontent.com/Svenskunganka/OpenLoad/master/templates/strapquery/img/unknown_map.jpg'>")

	local hostname = vgui.Create("DLabel", main)
	hostname:SetFont("SHB_Text")
	hostname:SetTextColor(theme.TextColor)
	hostname:SetText("Name Unavailable")
	hostname:SizeToContents()
	hostname:Dock(TOP)

	local playercount = vgui.Create("DLabel", main)
	playercount:SetFont("SHB_Text")
	playercount:SetTextColor(theme.TextColor)
	playercount:SetText("Could not retrieve server data!")
	playercount:SizeToContents()
	playercount:Dock(TOP)

	local connectbutton = vgui.Create("DButton", main)
	connectbutton:SetFont("SHB_Text")
	connectbutton:SetTextColor(theme.TextColor)
	connectbutton:SetDisabled(true)
	connectbutton:SetText("Connect")
	connectbutton:SizeToContents()
	connectbutton:DockMargin(0, 0, 10, 10)
	connectbutton:Dock(FILL)
	connectbutton.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, theme.ConnectButton)
	end
	connectbutton.DoClick = function()
		SHB.Window:Remove()
		LocalPlayer():ConCommand("connect " .. srvip)
	end

	SHB.GetServerInfo(id, function(data)
		if not data.success then return end

		if IsValid(imghtml) and IsValid(hostname) and IsValid(playercount) and IsValid(connectbutton) then
			if data.mapurl then
				imghtml:SetHTML("<img width='80px' height='60px' src='http://image.www.gametracker.com/images/maps/160x120/garrysmod/"..data.map..".jpg'>")
			end
			hostname:SetText(data.name)
			hostname:SizeToContents()
			playercount:SetText(data.players .. " / " .. data.maxplayers .. " players on ".. data.map)
			playercount:SizeToContents()
			connectbutton:SetDisabled(false)
		end
	end)

	return main
end

function SHB.OpenMenu()
	-- if SHB.Window then SHB.Window:Show() return end
	local theme = SHB.GetThemeColors(SHB.Theme)
	local width, height = ScrW() / 2, serversonpage * (ScrH() / 7)

	if servercount > 3 then
		height = height + 20
	end

	local frame = vgui.Create("DPanel")
	frame:SetSize(width, height)
	frame:SizeToContents()
	frame:Center()
	frame:MakePopup()
	frame:DockPadding(10, 35, 10, 10)
	frame.Paint = function(self, w, h)
		surface.SetDrawColor(theme.Background)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(theme.Header)
		surface.DrawRect(0, 0, w, 25)
	end
	SHB.Window = frame

	local close = vgui.Create("DButton", frame)
	close:SetText("X")
	close:SetTextColor(color_white)
	close:SetPos(SHB.Window:GetWide() - 45, 2)
	close:SetSize(40, 20)
	close.Paint = function(self, w, h)
		surface.SetDrawColor(theme.CloseButton)
		surface.DrawRect(0, 0, w, h)
	end
	close.DoClick = function()
		-- SHB.Window:Hide()
		SHB.Window:Remove()
		SHB.Window = nil
	end

	local title = vgui.Create("DLabel", frame) -- New title because new font
	title:SetPos(10, 2)
	title:SetTextColor(theme.HeaderTextColor)
	title:SetFont("SHB_Header")
	title:SetText(SHB.Title)
	title:SizeToContents()

	local serverpanels = {}
	for i = 1, servercount do -- Generate all server panels beforehand
		local pnl = ServerPanel(frame, i)
		pnl:SetVisible(false)
		serverpanels[i] = pnl
	end

	local function updateserverpanels()
		for k, v in pairs(serverpanels) do
			v:SetVisible(false)
		end
		for i = 1, serversonpage do
			local pnl = serverpanels[serversonpage * (currentpage - 1) + i]
			if not pnl then break end
			pnl:SetVisible(true)
			pnl:DockMargin(0, 0, 0, 15)
			pnl:Dock(TOP)
		end
	end
	updateserverpanels()

	if servercount > 3 then
		local forward, back
		surface.SetFont("SHB_PageButton")
		local charwidth = surface.GetTextSize(">")

		forward = vgui.Create("DButton", frame)
		forward:SetText("")
		forward:SetSize(75, 30)
		forward:SetPos(width * 0.75, height - 40)
		forward.Paint = function(self, w, h)
			draw.SimpleText(">", "SHB_PageButton", 0, 0, theme.TextColor)
		end
		forward.DoClick = function(self)
			currentpage = currentpage + 1
			updateserverpanels()
			if currentpage == pagecount then
				forward:SetVisible(false)
			end
			if currentpage ~= 1 and not back:IsVisible() then
				back:SetVisible(true)
			end
		end

		back = vgui.Create("DButton", frame)
		back:SetText("")
		back:SetSize(75, 30)
		back:SetPos(width * 0.25 - charwidth, height - 40)
		back:SetVisible(false)
		back.Paint = function(self, w, h)
			draw.SimpleText("<", "SHB_PageButton", 0, 0, theme.TextColor)
		end
		back.DoClick = function(self)
			currentpage = currentpage - 1
			updateserverpanels()
			if currentpage == 1 then
				back:SetVisible(false)
			end
			if currentpage ~= pagecount and not forward:IsVisible() then
				forward:SetVisible(true)
			end
		end
	end
end

concommand.Add(SHB.ConsoleCommand, function(ply, cmd, args, argsstr)
	SHB.OpenMenu()
end, nil, "Opens the Server Hopper menu.")

hook.Add("OnPlayerChat", "SHB_ChatCommand", function(ply, text, isteam, isdead)
	if ply == LocalPlayer() and string.find(string.lower(text), "^[/!]"..SHB.ChatCommand) then
		SHB.OpenMenu()
		return true
	end
end)
