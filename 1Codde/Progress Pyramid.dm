mob/verb
	BuySelectedJutsu()
		set hidden = 1

		switch(input("Are you sure you wish to buy this perk [src.databasejutsu.name]?","Confirmation") in list("No","Yes"))
			if("No")
				return
		//checks for requirements



		//req check success, buying perk now

		var/list/listed_requirements = src.databasejutsu.prerequisites.Copy()
		for(var/obj/jutsu/jutsu in src)
			if(jutsu.name in listed_requirements)
				listed_requirements -= jutsu.name
			else
				for(var/r in jutsu.encapsulates)
					if(r in listed_requirements)
						listed_requirements -= r
		if(listed_requirements.len || (control + control_boost()) < src.databasejutsu.control_req || (stamina + stamina_boost()) < src.databasejutsu.stamina_req)
			var/text = "You don't meet the requirements for [src.databasejutsu] ( "
			for(var/t in listed_requirements)
				text += "[t][length(text) > 45 ? ", " : ""] "
			if(src.databasejutsu.control_req) text += "[get_grade_stat(src.databasejutsu.control_req)] grade control[length(text) > 45 ? ", " : ""] "
			if(src.databasejutsu.stamina_req) text += "[get_grade_stat(src.databasejutsu.stamina_req)] grade stamina "
			text += ")"
			alert(src, text)
			return

		if(progress_points >= src.databasejutsu.point_cost || (points["spec"] && src.databasejutsu.spec_perk))
			if(!teach_jutsu(src.databasejutsu))
				alert("You already have [src.databasejutsu]")
				return
			var/a = 0
			if(points["spec"] && src.databasejutsu.spec_perk)
				points["spec"]--
				a = 1
			else progress_points -= src.databasejutsu.point_cost
			alert(src, "You have purchased [src.databasejutsu] for [a ? "1 free specialization" : src.databasejutsu.point_cost] point(s)")
		else
			alert(src, "You don't have enough points ([progress_points]/[src.databasejutsu.point_cost])")
