local name = minetest.get_player_by_name(name)

dofile(minetest.get_modpath("sv_tools") .. "/annon_grant.lua")
dofile(minetest.get_modpath("sv_tools") .. "/areas_violation.lua")
dofile(minetest.get_modpath("sv_tools") .. "/inter_keyword.lua")

minetest.register_chatcommand("sv_say", {
	params = "<action>",
	description = "Broadcast server mesasge.",
	privs = {server = true},
	func = function(name, param)
		minetest.chat_send_all("<Server> " .. param)
		return true, "Text was sent successfully"
	end,
})

minetest.register_chatcommand("sv_deluser", {
	params = "<action>",
	description = "deletes players file.",
	privs = {server = true},
	func = function(name, param)
		if name == "TheCWz" or name == "deezl" or name == "CWz"  then
			os.remove (minetest.get_worldpath().."/players/" ..param)
			return true, "<Server> player file deleted." 
		end
	end,
})
--server privs
minetest.register_privilege("basic_teleport", "Can use travelnets, home, gomine and spawn commands")
minetest.register_privilege("msg", "Can send players PMs")

--others

minetest.register_chatcommand("tprules", {
	params = "",
	description = "Teleport the player to spawn point",
	func = function(player, message)
		if not minetest.get_player_privs(player).basic_privs then
			minetest.chat_send_player(player, "Insufficient privileges", true)
			return
		end
		local tplayer = minetest.get_player_by_name(message)
		if not tplayer then
			minetest.chat_send_player(player, "Unknown player", true)
			return
		end
		tplayer:setpos({x=-24, y=9, z=-17})
	end
})

minetest.register_chatcommand("whois", {
	params = "",
	description = "Get player ip",
	privs = { server = true },
	func = function(player, message)
		local pinfo = minetest.get_player_information(message)
		if not pinfo then
			minetest.chat_send_player(player, "Failed to retrieve player info", true)
			return
		end
		minetest.chat_send_player(player,
			message .. ": " .. pinfo.address .. " (avg_rtt=" ..
			string.format("%.3f", pinfo.avg_rtt) .. ")", true)
	end
})
--[[
]]

minetest.register_chatcommand("ghost", {
	params = "",
	description = "Self kick",
	privs = {},
	func = function(name)
	minetest.kick_player(name,"You kicked yourself from the server.")
	end,
})
minetest.register_chatcommand("msg", {
	params = "<name> <message>",
	description = "Send a private message",
	privs = {shout=true, msg=true},
	func = function(name, param)
		local sendto, message = param:match("^(%S+)%s(.+)$")
		if not sendto then
			return false, "Invalid usage, see /help msg."
		end
		if not minetest.get_player_by_name(sendto) then
			return false, "The player " .. sendto
					.. " is not online."
		end
		minetest.log("action", "PM from " .. name .. " to " .. sendto
				.. ": " .. message)
		minetest.chat_send_player(sendto, "PM from " .. name .. ": "
				.. message)
		return true, "Message sent."
	end,
})
