--[[ Includes ]]--
include('sh_shb_config.lua')
--[[ Grab the Json ]]--
/*function SHB_ServerInfo( sid )
	local response = ""
	local url = SHB.ScriptURL
	
	http.Fetch( url .. "?ip=" .. SHB.IP[sid] .. "&port=" .. SHB.Port[sid],
	function( body, len, headers, code )
		response = body
		json = util.JSONToTable(response)
			return json
	end,
	function( error )
		json = "error"
		return json
	end	)
	
end*/

--[[ Ripped and Stripped GSapi ]]--
    local apiurl = SHB.ScriptURL
    local jdec = util.JSONToTable // futile attempt to make things faster
    local jenc = util.TableToJSON // futile attempt to make things faster

local function callbackCheck(code)
	assert(code~=401,"Authorization error (Is your key valid?)")
	assert(code~=500,"It seems the steam servers are having a hard time.") 
	assert(code~=404,"Not found.")
	assert(code~=400,"Bad module request.")
end

    function GetServerInfo(appid,callback,maxlen)
        assert(type(appid)=="number", "argument #1 to GetServerInfo, number expected; got " .. type(appid))
        assert(type(callback)=="function", "argument #2 to GetServerInfo, function expected; got " .. type(callback))
        http.Fetch(apiurl .. "?ip=" .. SHB.IP[appid] .. "&port=" .. SHB.Port[appid],
           function( body, _, _, code )
                  callbackCheck(code)
                  callback(jdec(body))
           end,
           function( error )
                  assert(false,error);
           end
        );
    end
