Exho the Server Hopping Bunny
===
This server hopper was created as a clone of a paid ScriptFodder addon. It provides a nice UI and a complete configuration system. It utilizes the source query API hosted on a webserver to deliver details about the servers.

[Facepunch post](http://facepunch.com/showthread.php?t=1421904&p=46205271&viewfull=1#post46205271)
### Screenshots
(Servers were random and reused because I was lazy)
![Interface](http://i.imgur.com/y8ljlHA.jpg)
![Interface](http://i.imgur.com/AvLFle4.jpg)
### Installation
1. Upload the *php_api* folder to your webserver and rename it or whatever.
2. Upload the *server_hopping_bunny* folder to your Garry's Mod addons folder.
3. In lua/shb/config.lua, change the ```SHB.ScriptURL``` to the folder you uploaded to your webserver.
4. In the same config file, copy the example ```SHB.AddServer()``` line and add all your servers.
5. Join your server and test it out!
### Configuration
SHB.ScriptURL: Location of the *php_api* folder on your webserver. For example, if I renamed the folder to "serverhopper", plopped it in the document root, and my website was example.net, this variable would be ```SHB.ScriptURL = "example.net/serverhopper"```.

SHB.ConsoleCommand: Console command used to open the Server Hopper menu.

SHB.ChatCommand: Chat command used to open the Server Hopper menu.

SHB.Title: Title displayed on the Server Hopper menu.

SHB.Theme: Color set to use. These are defined in shb/cl_themes.lua where you can find an example (the default).
### Bugs/requests
Post an issue on this page.
### Thanks to (in no particular order):
- BFG9000 for withstanding my annoying questions
- Exho for ripping off my idea of ripping off a CoderHire addon, and reigniting the idea to finished this addon (also the UI design)
- Svenskunganka for finding a missing semicolon and providing the missing map image
- rejax for some code in the past
- Freezebug for letting me rip off and butcher an function of GSapi in the past.
