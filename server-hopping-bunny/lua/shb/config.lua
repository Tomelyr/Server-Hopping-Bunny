SHB.ScriptURL = "http://example.com/serverhopper" -- The location of the folder you uploaded to your webserver.
SHB.ConsoleCommand = "serverhopper" -- Console command to open the Server Hopper menu.
SHB.ChatCommand = "servers" -- Chat command to open the Server Hopper menu.

SHB.Theme = "default" -- Check cl_themes.lua for information.

SHB.Title = "Server Hopper"

-- Servers are added to the list like this:
-- SHB.AddServer("ip", "port")

SHB.AddServer("0.0.0.0", "27015")
