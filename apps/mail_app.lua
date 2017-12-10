-- based on https://github.com/cheapie/mail

laptop.register_app("mail", {
	app_name = "Mail",
	app_icon = "laptop_email_letter.png",
	app_info = "Write mails to other players",
	formspec_func = function(app, mtos)
		local cloud = app:get_cloud_storage_ref("mail")
		if not mtos.appdata.os.last_player then
			mtos:set_app() -- no player. Back to launcher
			return false
		end

		if not cloud[mtos.appdata.os.last_player] then
			mtos:set_app("mail:newplayer")
			return false
		end
		local account = cloud[mtos.appdata.os.last_player]

		local formspec =
				"label[4,-0.31;Welcome "..mtos.appdata.os.last_player.."]"..

--				"textlist[0,0.5;7.5,8.2;message;"
				"tablecolumns[" ..
						"image,align=center,1=laptop_mail.png,2=laptop_mail_read.png;"..  --icon column
						"color;"..	-- subject and date color
						"text;".. -- subject
						"text,padding=1.5;".. -- sender
						"text,padding=1.5,align=right]".. -- date
				"table[0,0.5;7.5,8.2;message;"

		account.selected_inbox_index = nil
		if account.inbox[1] then
			for idx,message in ipairs(account.inbox) do
				if idx > 1 then
					formspec = formspec..','
				end
				-- set read/unread status
				if not message.is_read then
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

				-- set sender and date
				formspec = formspec..
						minetest.formspec_escape(message.sender or "") ..","..  -- body
						os.date("%c", message.time) -- timestamp
				if account.selectedmessage and
						message.sender == account.selectedmessage.sender and
						message.subject == account.selectedmessage.subject and
						message.time == account.selectedmessage.time and
						message.body == account.selectedmessage.body then
					account.selected_inbox_index = idx
				end
			end
			formspec = formspec .. ";"..(account.selected_inbox_index or "").."]"
		else
			formspec = formspec .. ",,No mail :(]"
		end

		formspec = formspec .. "button[0,9;1.5,0.5;new;New Message]"..
				"button[1.5,9;1.5,0.5;continue;Continue last mail]"
		if account.selectedmessage then
		formspec = formspec .. "button[3,9;1.5,0.5;reply;Reply]"..
				"button[4.5,9;1.5,0.5;forward;Forward]"..
				"button[6,9;1.5,0.5;delete;Delete]"..
				"button[8,9;1.5,0.5;markread;Mark Read]"..
				"button[9.5,9;1.5,0.5;markunread;Mark Unread]"
			local sender = minetest.formspec_escape(account.selectedmessage.sender) or ""
			local subject = minetest.formspec_escape(account.selectedmessage.subject) or ""
			local body = minetest.formspec_escape(account.selectedmessage.body) or ""
			formspec = formspec .. "label[8,0.5;From: "..sender.."]label[8,1;Subject: "..subject.."]textarea[8.25,1.5;7,8.35;body;;"..body.."]"
		end
		return formspec
	end,
	receive_fields_func = function(app, mtos, fields, sender)
		if sender:get_player_name() ~= mtos.appdata.os.last_player then
			mtos:set_app() -- wrong player. Back to launcher
			return
		end

		local cloud = app:get_cloud_storage_ref("mail")
		local account = cloud[mtos.appdata.os.last_player]
		local inbox = account.inbox

		-- Set read status if 2 seconds selected
		if account.selected_inbox_index and account.selectedmessage and
				account.selected_inbox_timestamp and (account.selected_inbox_timestamp - os.time()) > 2 then
			account.selectedmessage.is_read = true
		end

		if fields.message then
			local event = minetest.explode_table_event(fields.message)

			account.selectedmessage = inbox[event.row]
			if account.selectedmessage then
				account.selected_inbox_index = event.row
				account.selected_inbox_timestamp = os.time()
			else
				account.selected_inbox_index = nil
				account.selected_inbox_timestamp = nil
			end

		elseif fields.new then
			account.newmessage = {}
			mtos:set_app("mail:compose")
		elseif fields.continue then
			mtos:set_app("mail:compose")
		elseif account.selected_inbox_index then
			if fields.delete then 
				table.remove(inbox, account.selected_inbox_index)
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
			end
		end
	end
})

laptop.register_view("mail:newplayer", {
	formspec_func = function(app, mtos)
		return "label[1,3;No mail account for player "..mtos.appdata.os.last_player.. " found. Do you like to create a new account?]"..
				"image_button[1,4;3,1;"..mtos.theme.major_button..';create;Create account]'
	end,
	receive_fields_func = function(app, mtos, fields, sender)
		if sender:get_player_name() ~= mtos.appdata.os.last_player then
			mtos:set_app() -- wrong player. Back to launcher
			return
		end
		if fields.create then
			local cloud = app:get_cloud_storage_ref("mail")
			cloud[mtos.appdata.os.last_player] = {
				inbox = {},
				sentbox = {} --TODO 
			}
			app:back_app()
		elseif fields.os_back then
			app:exit_app()
		end
	end
})

-- Write new mail
laptop.register_view("mail:compose", {
	formspec_func = function(app, mtos)
		local cloud = app:get_cloud_storage_ref("mail")
		local account = cloud[mtos.appdata.os.last_player]
		account.newmessage = account.newmessage or {}
		local message = account.newmessage

		local formspec = "field[0.25,1;4,1;receiver;To:;%s]field[0.25,2;4,1;subject;Subject:;%s]textarea[0.25,3;8,4;body;;%s]button[5,8;2,1;send;Send]"
		formspec = string.format(formspec,minetest.formspec_escape(message.receiver or ""),minetest.formspec_escape(message.subject or ""),minetest.formspec_escape(message.body or ""))
		if message.receiver and not cloud[message.receiver] then
			formspec = formspec.."label[7,8;invalid receiver player]"
		end
		return formspec
	end,
	receive_fields_func = function(app, mtos, fields, sender)
		if sender:get_player_name() ~= mtos.appdata.os.last_player then
			mtos:set_app() -- wrong player. Back to launcher
			return
		end

		local cloud = app:get_cloud_storage_ref("mail")
		local account = cloud[mtos.appdata.os.last_player]
		account.newmessage = account.newmessage or {}
		local message = account.newmessage

		message.receiver = fields.receiver or message.receiver
		message.sender = mtos.appdata.os.last_player
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
