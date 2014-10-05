--[[ Includes ]]--
include('sh_shb_config.lua')
--[[ Grab the Json ]]--
function SHB_ServerInfo( sid )
	local response = ""
	local url = SHB.ScriptURL
	http.Post( url, {ip=SHB.IP[sid], port=SHB.Port[sid]},
	function( body, len, headers, code )
		response = body
		json = util.JSONToTable(response)
	end,
	function( error )
		json = "error"
	end	)
	
	return json
end

