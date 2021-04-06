/*

1/1/2017 avainer


external will be stored in Saga/Character Sheets/[ckey]

date is stored in DD/MM/YY no need for realtime so you can append entries the next day if you need to
*/

obj/char_sheet_msg
	var
		info = null
		lock = 0
		date = ""
		title= ""

character_sheet
	parent_type = /obj
	var
		owner_ckey = null
		list/entries = new()


	proc/
		clear()
			if(owner_ckey == null)
				return
			entries = list()
			write_file()
		append(obj/char_sheet_msg/C,mob/M)
			if(owner_ckey == null)
				return
			entries.Add(C)
			write_file()

		lock_previous(obj/char_sheet_msg/admin_review)
			for(var/obj/char_sheet_msg/C in src.entries)
				C.lock = 1
			append(admin_review)

		write_file()
			for(var/mob/M in world)
				if(M.ckey == owner_ckey)
					M.saveCharacterSheet()
					break



mob/var/mob/selected_player=null //for admins to view other peeps
mob/var/character_sheet/character_sheet = null


//mob control

mob/
	proc/
		flushOwnProgression()

			src << output(null, "char_sheet.outputCharSheet")
		//	src.loadCharacterSheet()

			for(var/obj/char_sheet_msg/entry in src.character_sheet.entries)
				src << output("[html_encode(entry.title)] - [html_encode(entry.date)] - [html_encode(entry.info)]", "char_sheet.outputCharSheet")



	verb/
		CloseProgression()
			set hidden = 1
			winshow(src,"char_sheet",0)

		OwnProgression() //loads and displays the mob's char sheet
			set hidden = 1
			winshow(src,"char_sheet",1)
			flushOwnProgression()

		OwnProgressionAppend()
			set hidden = 1
			if(!character_sheet)
				return
			var/obj/char_sheet_msg/C = new()
			C.date = input("What is the date of this? Use DD/MM/YY format!") as text

			var/title=""
			while(length(title) == 0)
				title= input("Title?") as text

			C.title = title
			C.info = input(src,"Describe what happened, be concise and specific:","Entry Information") as message

			character_sheet.append(C)
			src.flushOwnProgression()


		OwnProgressionEdit()
			//uses references to get the wanted entry then append it
			set hidden = 1
			if(!character_sheet) return
			var/list/choices
			for(var/obj/char_sheet_msg/C in character_sheet.entries)
				if(C.lock == 0)
					choices += "[C.title] - [C.date]"
			var/chosen_one = custom_alert3(choices, title = "Entry Selection")
			var/obj/char_sheet_msg/chosen_entry
			for(var/obj/char_sheet_msg/C in character_sheet.entries)
				if(C.lock == 0)
					if("[chosen_one]"	== "[C.title] - [C.date]")
					chosen_entry = C
					break

			chosen_entry.date = input("What is the date of this? Use DD/MM/YY format!") as text
			var/title=""
			while(length(title) == 0)
				title= input("What is the title of this entry?") as text
			chosen_entry.info = input(src,"Describe what happened, be concise and specific:","Entry Information") as message
			chosen_entry.title = title
			src.character_sheet.write_file()
			src.flushOwnProgression()

		OwnProgressionDelete()

			set hidden = 1
			if(!character_sheet) return
			var/list/choices
			for(var/obj/char_sheet_msg/C in character_sheet.entries)
				if(C.lock == 0)
					choices += "[C.title] - [C.date]"
			var/chosen_one = custom_alert3(choices, title = "Deletion")
			var/obj/char_sheet_msg/chosen_entry
			for(var/obj/char_sheet_msg/C in character_sheet.entries)
				if(C.lock == 0)
					if("[chosen_one]"	== "[C.title] - [C.date]")
					chosen_entry = C
					break

			src << "Deleted: [chosen_entry.date] - [chosen_entry.title] - [chosen_entry.info]"
			src.character_sheet.entries -= chosen_entry
			src.character_sheet.write_file()
			src.flushOwnProgression()


//general archive

mob/proc/
	loadCharacterSheet()
		if(!src.character_sheet)
			src.character_sheet = new/character_sheet
			src.character_sheet.owner_ckey = src.key

		if(fexists("Saga/Character Sheets/[src.ckey].sav"))
			var/savefile/F=file("Saga/Character Sheets/[src.ckey].sav")
			F["CharacterSheet"] >> src.character_sheet
			F["entries"] >> src.character_sheet.entries
			src.character_sheet.owner_ckey = src.ckey



	saveCharacterSheet()
		var/savefile/F=new("Saga/Character Sheets/[src.ckey].sav")
		F["CharacterSheet"] << src.character_sheet
		F["entries"] << src.character_sheet.entries

mob/verb/testCharSheet()
	world << src.character_sheet.owner_ckey

mob/Admin3
	verb/
		reviewCharSheet(mob/M)
			set name = "ViewCharSheet"
			set category = "Admin"

			//blah blah


		reward_Char_Sheet()
			var/obj/char_sheet_msg/review = input("Write down your review and reward. This will appear in the player's character sheet for them to view.")
			review.lock = 1
			review.date = time2text(world.realtime,"DD MM YYYY")
			review.title = "Review by [src.key]"
			selected_player.character_sheet.lock_previous(review)

//add: admin_add_entry, admin_clear_sheet, admin_hidden_entry O_O''