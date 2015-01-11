local keyword = "gariumpu"

minetest.register_chatcommand(keyword, {
	params = "keyword",
	description = "enter keyword to get interact",
	privs = {nointeract = true},
	func = function(player)
		--local player = minetest.get_player_by_name(player)
		minetest.set_player_privs(player, {
			interact = true,
			shout = true,
			spawn = true,
			home = true,
			nointeract = nil,
		})
		minetest.chat_send_all("<Server> player, "..player.." Read the rules and has been granted interact!")
		minetest.chat_send_player(player, "<Server> to "..player..": This Keyword is not to be told to anyone who is not an admin.")
		if minetest.get_modpath("irc") then
			irc:say(("* %s %s"):format("", "player, "..player.." Read the rules and has been granted interact!"))
		end
	end,
})
minetest.register_privilege("nointeract", "Can enter keyword to get interact")
