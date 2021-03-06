mob
	var/tmp
		character_box/character_box

	verb
		character_box()
			set hidden = 1
			if(!character_box)
				character_box = new(src)
				character_box.center(src)
				spawn(1)
					character_box.show()
					character_box.expand_stats(src)
			else
				character_box.center(src)
				if(character_box.visible)
					character_box.hide()
				else
					character_box.show()

allocate_button
	parent_type = /HudObject
	layer = 93000000
	var/stat

	mouse_over_pointer = MOUSE_HAND_POINTER

	Click()
		usr.allocate_stats(stat)


text_box
	parent_type = /HudObject
	layer = 92000000
	plane = 100
	proc/display_text(t)
		overlays = null
		overlays += t
		for(var/index = 1 to overlays.len)
			var image/i = image(overlays[index])
			overlays -= i
			i.plane = plane
			overlays += i
bar
	parent_type = /HudObject
	layer = 93000000
	icon = 'Barhealth.dmi'
	proc/Adjust(f)
		var/animation_time = 6
		var/original_width = 1 // pixels of the icon itself
		var/full_width = 160
		var/fullness = f //M.Health.Value / (M.Health.Max + M.Health.Bonus)
		var/actual_width = full_width * fullness
		var/scale_x = actual_width / original_width
		var/scale_y = 1 // height unchanged
		var/offset_x = 2 + actual_width / 2
		var/offset_y = 2
		var/matrix/m = new
		m.Scale(scale_x, scale_y)
		m.Translate(offset_x, offset_y)
		animate(src, transform = m, time = animation_time)

expand_button
	parent_type = /HudObject
	layer = 92000000
	var/state = "down"

	mouse_over_pointer = MOUSE_HAND_POINTER

	Click()
		usr.character_box.expand(usr)

	MouseEntered()
		icon_state = "[state]2"

	MouseExited()
		icon_state = "[state]1"

plus_button
	parent_type = /HudObject
	layer = 92000000
	var/state = "plus"

	mouse_over_pointer = MOUSE_HAND_POINTER

	Click()
		usr.character_box.expand_stats(usr)

	MouseEntered()
		icon_state = "[state]2"

	MouseExited()
		icon_state = "[state]1"

avatar_box
	parent_type = /HudObject
	layer = 92000000
	icon_state = "card1"

character_info
	parent_type = /HudGroup

	icon = 'Characterinfo.dmi'
	layer = 92000000

	var/text_box/clan
	var/text_box/village
	var/text_box/age
	var/text_box/attitude
	var/text_box/class
	var/text_box/points


	New(mob/m)
		..()

		for(var/x = 0 to 7)
			for(var/y = 0 to 2)
				var/px = x * 32
				var/py = y * 32 - 84
				add(px, py, icon_state = "[x],[y]")

		clan = new(src, 'Blank.dmi', "blank")
		clan.pos(47, -37)
		add(clan)

		village = new(src, 'Blank.dmi', "blank")
		village.pos(152, -37)
		add(village)

		age = new(src, 'Blank.dmi', "blank")
		age.pos(47, -55)
		add(age)

		attitude = new(src, 'Blank.dmi', "blank")
		attitude.pos(152, -55)
		add(attitude)

		class = new(src, 'Blank.dmi', "blank")
		class.pos(47, -73)
		add(class)

		points = new(src, 'Blank.dmi', "blank")
		points.pos(152, -73)
		add(points)

allocate_buttons
	parent_type = /HudGroup

	icon = 'Statbox.dmi'
	layer = 92000000

	var/list/allocate_button/allocate_buttons[6]

	New(mob/m)
		..()

		var/allocate_button/allocate_button = new(src, icon, "+")
		allocate_button.pos(96, -137)
		allocate_button.stat = "strength"
		add(allocate_button)
		allocate_buttons[1] = allocate_button

		allocate_button = new(src, icon, "+")
		allocate_button.pos(201, -137)
		allocate_button.stat = "endurance"
		add(allocate_button)
		allocate_buttons[2] = allocate_button

		allocate_button = new(src, icon, "+")
		allocate_button.pos(96, -154)
		allocate_button.stat = "agility"
		add(allocate_button)
		allocate_buttons[3] = allocate_button

		allocate_button = new(src, icon, "+")
		allocate_button.pos(201, -154)
		allocate_button.stat = "speed"
		add(allocate_button)
		allocate_buttons[4] = allocate_button

		allocate_button = new(src, icon, "+")
		allocate_button.pos(96, -171)
		allocate_button.stat = "stamina"
		add(allocate_button)
		allocate_buttons[5] = allocate_button

		allocate_button = new(src, icon, "+")
		allocate_button.pos(201, -171)
		allocate_button.stat = "control"
		add(allocate_button)
		allocate_buttons[6] = allocate_button



character_stats
	parent_type = /HudGroup

	icon = 'Statbox.dmi'
	layer = 92000000

	var/text_box/points

	var/text_box/strength
	var/text_box/endurance
	var/text_box/agility
	var/text_box/speed
	var/text_box/stamina
	var/text_box/control

	New(mob/m)
		..()

		for(var/x = 0 to 7)
			for(var/y = 0 to 3)
				var/px = x * 32
				var/py = y * 32 - 190
				add(px, py, icon_state = "[x],[y]")

		points = new(src, 'Blank.dmi', "blank")
		points.pos(170, -127)
		add(points)

		strength = new(src, 'Blank.dmi', "blank")
		strength.pos(81, -157)
		add(strength)

		endurance = new(src, 'Blank.dmi', "blank")
		endurance.pos(188, -157)
		add(endurance)

		agility = new(src, 'Blank.dmi', "blank")
		agility.pos(81, -174)
		add(agility)

		speed = new(src, 'Blank.dmi', "blank")
		speed.pos(188, -174)
		add(speed)

		stamina = new(src, 'Blank.dmi', "blank")
		stamina.pos(81, -191)
		add(stamina)

		control = new(src, 'Blank.dmi', "blank")
		control.pos(188, -191)
		add(control)

character_box
	parent_type = /HudGroup

	icon = 'Characterbox.dmi'
	layer = 90000000

	var/text_box/name_info

	var/expand_button/expand_button

	var/plus_button/plus_button

	var/character_info/character_info

	var/character_stats/character_stats

	var/allocate_buttons/allocate_buttons

	var/avatar_box/avatar_box

	var/bar/health_bar
	var/bar/chakra_bar
	var/bar/progress_bar

	New(mob/m)
		..()

		for(var/x = 0 to 7)
			for(var/y = 0 to 2)
				var/px = x * 32
				var/py = y * 32
				add(px, py, icon_state = "[x],[y]")

		name_info = new(src, 'Blank.dmi', "blank")
		name_info.pos(8, 35)
		add(name_info)

		expand_button = new(src, icon, "down1")
		expand_button.pos(197, 50)
		add(expand_button)

		plus_button = new(src, icon, "plus1")
		plus_button.pos(178, 50)
		add(plus_button)

		avatar_box = new(src, icon, "card1")
		avatar_box.pos(11, 11)
		add(avatar_box)

		health_bar = new(src, 'newbarprog.dmi', "20")
		health_bar.pos(54, 35)
		health_bar.color = "#b60909"
		add(health_bar)

		chakra_bar = new(src, 'newbarprog.dmi', "20")
		chakra_bar.pos(54, 25)
		chakra_bar.color = "#1205cc"
		add(chakra_bar)

		progress_bar = new(src, 'newbarprog.dmi', "0")
		progress_bar.pos(54, 10)
		progress_bar.color = "#099b46"
		add(progress_bar)

		character_info = new(m)
		add(character_info)

		character_stats = new(m)
		add(character_stats)

		allocate_buttons = new(m)
		add(allocate_buttons)

		update_info(m)

	show()
		..()
		expand(usr)

	proc/center(var/mob/user)
		if(!user.client) return
		var/size = winget(user, "mappane", "size")
		if(!user.client) return
		var/width = text2num(copytext(size, 1, findtext(size, "x", 1, length(size) + 1)))
		var/height = text2num(copytext(size, findtext(size, "x", 1, length(size) + 1) + 1, length(size) + 1))

		var/cwidth = user.get_client_width() * 32
		var/cheight = user.get_client_height() * 32

		var/i = round((cwidth - width) * 0.5)
		var/j = round((cheight - height) * 0.5)

		pos(-1 + i, user.get_client_height() * 32 - 76 - j + 1)

	proc/expand(var/mob/user)
		if(character_info.visible)
			expand_button.state = "down"
			expand_button.icon_state = "down1"
			if(character_stats.visible)
				character_stats.toggle()
				allocate_buttons.toggle()
		else
			expand_button.state = "up"
			expand_button.icon_state = "up1"
		character_info.toggle()
		update_info(user)

	proc/expand_stats(var/mob/user)
		if(!character_info.visible)
			expand(user)
		character_stats.toggle()
		allocate_buttons.toggle()
		update_stats(user)

	proc/update_info(var/mob/user)
		if(!archive.info_text["[user.name]"])
			archive.info_text["[user.name]"] = drawfont.QuickText(src, "[user.name]", "#E6C208", 1, layer = 93000000)
		name_info.display_text(archive.info_text["[user.name]"])

		if(!archive.info_text["[user.Clan]"])
			archive.info_text["[user.Clan]"] = drawfont.QuickText(src, "[user.Clan]", "#FFFDCA", 1, layer = 93000000)
		character_info.clan.display_text(archive.info_text["[user.Clan]"])

		if(!archive.info_text["[user.Village]"])
			archive.info_text["[user.Village]"] = drawfont.QuickText(src, "[user.Village]", "#FFFDCA", 1, layer = 93000000)
		character_info.village.display_text(archive.info_text["[user.Village]"])

		if(!archive.info_text["[user.Age]"])
			archive.info_text["[user.Age]"] = drawfont.QuickText(src, "[user.Age]", "#FFFDCA", 1, layer = 93000000)
		character_info.age.display_text(archive.info_text["[user.Age]"])

		if(!user.trait_text)
			user.trait_text = drawfont.QuickText(src, "[user.Trait]", "#FFFDCA", 1, layer = 930000002)
		character_info.attitude.display_text(user.trait_text)

		if(!archive.info_text["[user.Class] ([get_rank_grade(user)])"])
			archive.info_text["[user.Class] ([get_rank_grade(user)])"] = drawfont.QuickText(src, "[user.Class] ([get_rank_grade(user)])", "#009300", 1, layer = 93000000)
		character_info.class.display_text(archive.info_text["[user.Class] ([get_rank_grade(user)])"])
		if(user.Trait == "Skilled")
			if(user.got_skill < 1 && user.total_stats()-30 >= 140)
				user.points["skill"]++
			else if(user.got_skill == 2 && user.total_stats()-30 >= 220)
				user.points["skill"]++
			else if(user.got_skill == 3 && user.total_stats()-30 >= 269)
				user.points["skill"]++
			else if(user.got_skill == 4 && user.total_stats()-30 >= 309)
				user.points["skill"]++
			world<<user.points["skill"]


		if(!archive.info_text["[user.progress_points]/[user.lifetime_progress_points] points"])
			archive.info_text["[user.progress_points]/[user.lifetime_progress_points] points"] = drawfont.QuickText(src, "[user.progress_points]/[user.lifetime_progress_points] points", "#FFFDCA", 1, layer = 93000000)
		character_info.points.display_text(archive.info_text["[user.progress_points]/[user.lifetime_progress_points] points"])


		var icon/aicon = icon(user.icon)
		aicon.Scale(32,32)

		avatar_box.icon = aicon // user

		avatar_box.overlays = user.overlays
		for(var/index = 1 to avatar_box.overlays.len)
			var image/i = image(avatar_box.overlays[index])
			avatar_box.overlays -= i
			i.plane = 100
			avatar_box.overlays += i

		update_bars(user)

	proc/update_stats(var/mob/user)

		var/t = "[user.stat_points] points "
		if(!archive.info_text[t])
			archive.info_text[t] = drawfont.QuickText(src, "[t]", "#FFFDCA", 1, layer = 93000000)
		character_stats.points.display_text(archive.info_text[t])
		var/stat_limit = round((user.total_stats() + user.stat_points) / archive.stat_limit_reducer)

		t = "[get_grade_stat(user.strength + user.strength_boost())]"
		if(user.able_bodied.len > 0 && "strength" in user.able_bodied && user.strength >= stat_limit + user._get_step_size(get_grade_stat(stat_limit)))
			if(!archive.info_text_green[t])
				archive.info_text_green[t] = drawfont.QuickText(src, "[t]", "#f8c621", 1, layer = 93000000)
		else if(user.strength >= stat_limit)
			if(!archive.info_text_green[t])
				archive.info_text_green[t] = drawfont.QuickText(src, "[t]", "#009300", 1, layer = 93000000)
		else if(user.strength + user.strength_boost() < 1)
			t = "[get_grade_stat(1)]"
			if(!archive.info_text_red[t])
				archive.info_text_red[t] = drawfont.QuickText(src, "1", "#ff6666", 1, layer = 93000000)
		else if(!archive.info_text[t])
			archive.info_text[t] = drawfont.QuickText(src, "[t]", "#FFFDCA", 1, layer = 93000000)
		character_stats.strength.display_text(user.strength >= stat_limit ? archive.info_text_green[t] : (user.strength + user.strength_boost() < 1 ? archive.info_text_red[t] : archive.info_text[t]))

		t = "[get_grade_stat(user.endurance + user.endurance_boost())]"
		if(user.able_bodied.len > 0 && "endurance" in user.able_bodied && user.endurance >= stat_limit + user._get_step_size(get_grade_stat(stat_limit)))
			if(!archive.info_text_green[t])
				archive.info_text_green[t] = drawfont.QuickText(src, "[t]", "#f8c621", 1, layer = 93000000)
		else if(user.endurance >= stat_limit)
			if(!archive.info_text_green[t])
				archive.info_text_green[t] = drawfont.QuickText(src, "[t]", "#009300", 1, layer = 93000000)
		else if(user.endurance + user.endurance_boost() < 1)
			t = "[get_grade_stat(1)]"
			if(!archive.info_text_red[t])
				archive.info_text_red[t] = drawfont.QuickText(src, "1", "#ff6666", 1, layer = 93000000)
		else if(!archive.info_text[t])
			archive.info_text[t] = drawfont.QuickText(src, "[t]", "#FFFDCA", 1, layer = 93000000)
		character_stats.endurance.display_text(user.endurance >= stat_limit ? archive.info_text_green[t] : (user.endurance + user.endurance_boost() < 1 ? archive.info_text_red[t] : archive.info_text[t]))

		t = "[get_grade_stat(user.agility + user.agility_boost())]"
		if(user.able_bodied.len > 0 && "agility" in user.able_bodied && user.agility >= stat_limit + user._get_step_size(get_grade_stat(stat_limit)))
			if(!archive.info_text_green[t])
				archive.info_text_green[t] = drawfont.QuickText(src, "[t]", "#f8c621", 1, layer = 93000000)
		else if(user.agility >= stat_limit)
			if(!archive.info_text_green[t])
				archive.info_text_green[t] = drawfont.QuickText(src, "[t]", "#009300", 1, layer = 93000000)
		else if(user.agility + user.agility_boost() < 1)
			t = "[1]"
			if(!archive.info_text_red[t])
				archive.info_text_red[t] = drawfont.QuickText(src, "1", "#ff6666", 1, layer = 93000000)
		else if(!archive.info_text[t])
			archive.info_text[t] = drawfont.QuickText(src, "[t]", "#FFFDCA", 1, layer = 93000000)
		character_stats.agility.display_text(user.agility >= stat_limit ? archive.info_text_green[t] : (user.agility + user.agility_boost() < 1 ? archive.info_text_red[t] : archive.info_text[t]))

		t = "[get_grade_stat(user.speed + user.speed_boost())]"
		if(user.able_bodied.len > 0 && "speed" in user.able_bodied && user.speed >= stat_limit + user._get_step_size(get_grade_stat(stat_limit)))
			if(!archive.info_text_green[t])
				archive.info_text_green[t] = drawfont.QuickText(src, "[t]", "#f8c621", 1, layer = 93000000)
		else if(user.speed >= stat_limit)
			if(!archive.info_text_green[t])
				archive.info_text_green[t] = drawfont.QuickText(src, "[t]", "#009300", 1, layer = 93000000)
		else if(user.speed + user.speed_boost() < 1)
			t = "[1]"
			if(!archive.info_text_red[t])
				archive.info_text_red[t] = drawfont.QuickText(src, "1", "#ff6666", 1, layer = 93000000)
		else if(!archive.info_text[t])
			archive.info_text[t] = drawfont.QuickText(src, "[t]", "#FFFDCA", 1, layer = 93000000)
		character_stats.speed.display_text(user.speed >= stat_limit ? archive.info_text_green[t] : (user.speed + user.speed_boost() < 1 ? archive.info_text_red[t] : archive.info_text[t]))
		t = "[get_grade_stat(user.stamina + user.stamina_boost(),1)]"
		if(user.able_bodied.len > 0 && "stamina" in user.able_bodied && user.stamina >= stat_limit + user._get_step_size(get_grade_stat(stat_limit)))
			if(!archive.info_text_green[t])
				archive.info_text_green[t] = drawfont.QuickText(src, "[t]", "#f8c621", 1, layer = 93000000)
		else if(user.stamina >= stat_limit + 10)
			if(!archive.info_text_green[t])
				archive.info_text_green[t] = drawfont.QuickText(src, "[t]", "#009300", 1, layer = 93000000)
		else if(user.stamina + user.stamina_boost() < 1)
			t = "[get_grade_stat(1)]"
			if(!archive.info_text_red[t])
				archive.info_text_red[t] = drawfont.QuickText(src, "1", "#ff6666", 1, layer = 93000000)
		else if(!archive.info_text[t])
			archive.info_text[t] = drawfont.QuickText(src, "[t]", "#FFFDCA", 1, layer = 93000000)
		character_stats.stamina.display_text(user.stamina >= stat_limit + 10 ? archive.info_text_green[t] : (user.stamina + user.stamina_boost() < 1 ? archive.info_text_red[t] : archive.info_text[t]))

		t = "[get_grade_stat(user.control + user.control_boost())]"
		if(user.control + user.control_boost() >= stat_limit)
			if(!archive.info_text_green[t])
				archive.info_text_green[t] = drawfont.QuickText(src, "[t]", "#009300", 1, layer = 93000000)
		else if(user.control < 1)
			t = "[get_grade_stat(1)]"
			if(!archive.info_text_red[t])
				archive.info_text_red[t] = drawfont.QuickText(src, "1", "#ff6666", 1, layer = 93000000)
		else if(!archive.info_text[t])
			archive.info_text[t] = drawfont.QuickText(src, "[t]", "#FFFDCA", 1, layer = 93000000)
		character_stats.control.display_text(user.control >= stat_limit ? archive.info_text_green[t] : (user.control + user.control_boost() < 1 ? archive.info_text_red[t] : archive.info_text[t]))
		update_bars(user)
	proc/set_health(num)
		health_bar.Adjust(num)
	proc/set_chakra(num)
		chakra_bar.Adjust(num)
	proc/set_calories(num)
		return
		progress_bar.Adjust(num)
	proc/set_swarms(num)
		return
		progress_bar.Adjust(num)
	proc/set_progress(num)
		if(num >= 1)
			progress_bar.Adjust(1)
			return
		progress_bar.Adjust(num)
	proc/update_bars(var/mob/user)
		set_health(user.stamina_current/(user.get_stamina()))
		set_chakra(user.chakra_current/(user.get_chakra()))
		set_progress(user.daily_points/archive.check_threshold)

