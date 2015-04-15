-- Here you can define color schemes for the Server Hopper menu.
-- The default theme, "default", is provided as an example.
-- To select a theme, change the SHB.Theme line in config.lua to the name of the specified theme.

local themes = {}

function SHB.AddTheme(name, data)
	data.Header				= data.Header or Color(44, 62, 80)
	data.Background			= data.Background or Color(52, 73, 94)
	data.TextColor			= data.TextColor or color_black
	data.HeaderTextColor	= data.HeaderTextColor or color_white
	data.ServerPanelBG		= data.ServerPanelBG or Color(204, 204, 204)
	data.ConnectButton		= data.ConnectButton or Color(107, 107, 107)
	data.CloseButton		= data.CloseButton or Color(200, 79, 79)

	themes[name] = data
end

SHB.AddTheme("default", {
	Header			= Color(44, 62, 80),
	Background		= Color(52, 73, 94),
	TextColor		= color_black,
	HeaderTextColor	= color_white,
	ServerPanelBG	= Color(204, 204, 204),
	ConnectButton	= Color(107, 107, 107),
	CloseButton		= Color(200, 79, 79),
})

function SHB.GetThemeColors(name)
	return themes[name]
end
