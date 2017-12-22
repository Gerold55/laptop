-- based on https://github.com/cheapie/mail

laptop.register_app("mail", {
	app_name = "Mail",
	app_icon = "laptop_email_letter.png",
	app_info = "Write mails to other players",
	formspec_func = function(app, mtos)
		local cloud = mtos.bdev:get_app_storage('cloud', 'mail')
		if not cloud then
			mtos:set_app("mail:nonet")
			return false
		end

		if not mtos.sysram.last_player then
			mtos:set_app() -- no player. Back to launcher
			return false
		end

		if not cloud[mtos.sysram.last_player] then
			mtos:set_app("mail:newplayer")
			return false
		end
		local account = cloud[mtos.sysram.last_player]
		account.selected_box = account.selected_box or "inbox"
		account.selected_index = nil -- will be new determinated by selectedmessage
		local box = account[account.selected_box] -- inbox or outbox

		app.app_info = app.app_info.." - Welcome "..mtos.sysram.last_player.."]"
		local formspec =
				"tablecolumns[" ..
						"image,align=center,1=laptop_mail.png,2=laptop_mail_read.png;"..  --icon column
						"color;"..	-- subject and date color
						"text;".. -- subject
						"text,padding=1.5;".. -- sender
						"text,padding=1.5,align=right]".. -- date
				"table[0,0.5;7.5,8.2;message;"

		if box and box[1] then
			for idx,message in ipairs(box) do
				if idx > 1 then
					formspec = formspec..','
				end
				-- set read/unread status
				if account.selected_box == "sentbox" then
					formspec = formspec .. "1,#88FF88," -- unread
				elseif not message.is_read then
					formspec = formspec .. "1,#FF8888," -- unread
				else
					formspec = formspec .. "2,#FFFFFF," -- read
				end

				-- set subject
				if not message.subject or message.subject == "" then
					formspec = formspec .. "(No subject),"
				elseif string.len(message.subject) > 30 then
					formspec = formspec .. minetest.formspec_escape(string.sub(message.subject,1,27)) .. "...,"
				else
					formspec = formspec .. minetest.formspec_escape(message.subject) .. ","
				end

				-- set sender or receiver
				if account.selected_box == "inbox" then
					formspec = formspec..minetest.formspec_escape(message.sender or "") ..","  -- body
				else
					formspec = formspec..minetest.formspec_escape(message.receiver or "") ..","  -- body
				end

				-- set date
				formspec = formspec .. os.date("%c", message.time) -- timestamp

				-- handle marked line
				if account.selectedmessage and
						message.sender == account.selectedmessage.sender and
						message.subject == account.selectedmessage.subject and
						message.time == account.selectedmessage.time and
						message.body == account.selectedmessage.body then
					account.selected_index = idx
				end
			end
			formspec = formspec .. ";"..(account.selected_index or "").."]"
		else
			formspec = formspec .. ",,No mail :(]"
		end

		-- toggle inbox/sentbox
		if account.selected_box == "inbox" then
			formspec = formspec .. mtos.theme:get_image_button('0,9;1,1', 'minor', 'switch_sentbox', 'laptop_mail_sentbox.png', '', 'Show sent messages')
		else
			formspec = formspec .. mtos.theme:get_image_button('0,9;1,1', 'minor', 'switch_inbox', 'laptop_mail_received.png', '', 'Show received messages')
		end

		formspec = formspec .. mtos.theme:get_image_button('1.7,9;1,1', 'minor', 'new', 'laptop_email_new.png', '', 'New message')
		if account.newmessage then
			formspec = formspec .. mtos.theme:get_image_button('2.7,9;1,1', 'minor', 'continue', 'laptop_email_edit.png', '', 'Continue last message')
		end

		if account.selectedmessage then
			formspec = formspec ..
					mtos.theme:get_image_button('3.7,9;1,1', 'minor', 'reply', 'laptop_email_reply.png', '', 'Reply')..
					mtos.theme:get_image_button('4.7,9;1,1', 'minor', 'forward', 'laptop_email_forward.png', '', 'Forward')..
					mtos.theme:get_image_button('5.7,9;1,1', 'minor', 'delete', 'laptop_email_trash.png', '', 'Delete')
			if account.selected_box == "inbox" then
				if not account.selectedmessage.is_read then
					formspec = formspec .. mtos.theme:get_image_button('6.7,9;1,1', 'minor', 'markread', 'laptop_mail_read_button.png', '', 'Mark message as read')
				else
					formspec = formspec .. mtos.theme:get_image_button('6.7,9;1,1', 'minor', 'markunread', 'laptop_mail_button.png', '', 'Mark message as unread')
				end
			end
			if account.selected_box == "inbox" then
				formspec = formspec .. mtos.theme:get_label('8,0.5', "From: "..(account.selectedmessage.sender or ""))
			else
				formspec = formspec .. mtos.theme:get_label('8,0.5', "To: "..(account.selectedmessage.receiver or ""))
			end

			formspec = formspec .. mtos.theme:get_label('8,1', "Subject: "..(account.selectedmessage.subject or ""))..
					"background[8,1.55;6.92,7.3;"..mtos.theme.contrast_bg.."]"..
					"textarea[8.35,1.6;6.8,8.25;;"..(minetest.formspec_escape(account.selectedmessage.body) or "")..";]"
		end
		return formspec
	end,
	receive_fields_func = function(app, mtos, sender, fields)
		if sender:get_player_name() ~= mtos.sysram.last_player then
			mtos:set_app() -- wrong player. Back to launcher
			return
		end

		local cloud = mtos.bdev:get_app_storage('cloud', 'mail')
		local account = cloud[mtos.sysram.last_player]
		if not account then
			mtos:set_app() -- wrong player. Back to launcher
			return
		end
		account.selected_box = account.selected_box or "inbox"
		local box = account[account.selected_box] -- inbox or outbox

		-- Set read status if 2 seconds selected
		if account.selected_index and account.selectedmessage and account.selected_box == "inbox" and
				account.selected_timestamp and (os.time() - account.selected_timestamp) > 1 then
			account.selectedmessage.is_read = true
		end

		-- process input
		if fields.message then
			local event = minetest.explode_table_event(fields.message)
			account.selectedmessage = box[event.row]
			if account.selectedmessage then
				account.selected_index = event.row
				account.selected_timestamp = os.time()
			else
				account.selected_index = nil
			end
		elseif fields.new then
			account.newmessage = {}
			mtos:set_app("mail:compose")
		elseif fields.continue then
			mtos:set_app("mail:compose")
		elseif fields.switch_sentbox then
			account.selected_box = "sentbox"
			account.selectedmessage = nil
		elseif fields.switch_inbox then
			account.selected_box = "inbox"
			account.selectedmessage = nil
		elseif account.selected_index then
			if fields.delete then 
				table.remove(box, account.selected_index)
				account.selectedmessage = nil
			elseif fields.reply then
				account.newmessage = {}
				account.newmessage.receiver = account.selectedmessage.sender
				account.newmessage.subject = "Re: "..(account.selectedmessage.subject or "")
				account.newmessage.body = "Type your reply here."..string.char(10)..string.char(10).."--Original message follows--"..string.char(10)..(account.selectedmessage.body or "")
				mtos:set_app("mail:compose")
			elseif fields.forward then
				account.newmessage = {}
				account.newmessage.subject = "Fw: "..(account.selectedmessage.subject or "")
				account.newmessage.body = "Type your reply here."..string.char(10)..string.char(10).."--Original message follows--"..string.char(10)..(account.selectedmessage.body or "")
				mtos:set_app("mail:compose")
			elseif fields.markread then
				account.selectedmessage.is_read = true
			elseif fields.markunread then
				account.selectedmessage.is_read = false
				account.selected_timestamp = nil -- Stop timer
			end
		end
	end
})

laptop.register_view("mail:newplayer", {
	formspec_func = function(app, mtos)
		return mtos.theme:get_label('1,3', "No mail account for player "..mtos.sysram.last_player.. " found. Do you like to create a new account?")..
				mtos.theme:get_button('1,4;3,1', 'major', 'create', 'Create account')
	end,
	receive_fields_func = function(app, mtos, sender, fields)
		if sender:get_player_name() ~= mtos.sysram.last_player then
			mtos:set_app() -- wrong player. Back to launcher
			return
		end
		if fields.create then
			local cloud = mtos.bdev:get_app_storage('cloud', 'mail')
			cloud[mtos.sysram.last_player] = {
				inbox = {},
				sentbox = {}
			}
			app:back_app()
		elseif fields.os_back then
			app:exit_app()
		end
	end
})

laptop.register_view("mail:nonet", {
	formspec_func = function(app, mtos)
		return mtos.theme:get_label('1,3', "No internet available on this computer")
	end,
	receive_fields_func = function(app, mtos, sender, fields)
		app:exit_app()
	end
})

-- Write new mail
laptop.register_view("mail:compose", {
	formspec_func = function(app, mtos)
		local cloud = mtos.bdev:get_app_storage('cloud', 'mail')
		local account = cloud[mtos.sysram.last_player]
		account.newmessage = account.newmessage or {}
		local message = account.newmessage

		local formspec = "background[0,0.4;8,2.4;"..mtos.theme.contrast_bg.."]"..
				"label[0.25,2;Subject:]".."field[2.7,2;5,1;subject;;"..minetest.formspec_escape(message.subject or "").."]"..
				"background[0,3.05;7.95,3.44;"..mtos.theme.contrast_bg.."]"..
				"textarea[0.25,3;8,4;body;;"..minetest.formspec_escape(message.body or "").."]"..
				mtos.theme:get_button("0,8;2,1", "major", "send", "Send message")..
				"label[0.25,0.75;Receiver:]".."dropdown[2.4,0.75;5.2,1;receiver;"

		local sortedtab = {}
		for playername,_ in pairs(cloud) do
			table.insert(sortedtab, playername)
		end
		table.sort(sortedtab)

		local selected_idx
		for idx, playername in ipairs(sortedtab) do
			formspec = formspec..',' .. minetest.formspec_escape(playername)
			if playername == message.receiver then
				selected_idx = idx+1 -- +1 because of empty entry
			end
		end
		formspec = formspec .. ";"..(selected_idx or "").."]"

		if message.receiver and not cloud[message.receiver] then
			formspec = formspec..mtos.theme:get_label('2.3,8', "invalid receiver player")
		end
		return formspec
	end,
	receive_fields_func = function(app, mtos, sender, fields)
		if sender:get_player_name() ~= mtos.sysram.last_player then
			mtos:set_app() -- wrong player. Back to launcher
			return
		end

		local cloud = mtos.bdev:get_app_storage('cloud', 'mail')
		local account = cloud[mtos.sysram.last_player]
		account.newmessage = account.newmessage or {}
		local message = account.newmessage

		message.receiver = fields.receiver or message.receiver
		message.sender = mtos.sysram.last_player
		message.time = os.time()
		message.subject = fields.subject or message.subject
		message.body = fields.body or message.body

		if fields.send and message.receiver and cloud[message.receiver] then
			table.insert(cloud[message.receiver].inbox, message)
			table.insert(account.sentbox, table.copy(message))
			account.newmessage = nil
			app:back_app()
		end
	end
})
