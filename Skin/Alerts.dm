
mob
	verb
		login_box()
			set hidden = 1

			if(!client) return

			var/pos = winget(src, "default.screenlabel", "size")
			var/xx = text2num(copytext(pos, 1, findtext(pos, "x", 1, length(pos) + 1)))
			var/yy = text2num(copytext(pos, findtext(pos, "x", 1, length(pos) + 1) + 1, length(pos) + 1))

			var/pos1 = winget(src, "default", "pos")
			//var/xx1 = text2num(copytext(pos1, 1, findtext(pos1, ",", 1, length(pos1) + 1)))
			var/yy1 = text2num(copytext(pos1, findtext(pos1, ",", 1, length(pos1) + 1) + 1, length(pos1) + 1))

			winset(src, "welcome", "pos=[(xx/2) - 210],[yy1 + (yy/2) - 360]")

			src << browse_rsc('loginbackground.png')
			src << output(archive.login_screen, "welcome.browser")
			winshow(src, "welcome", 1)

		login_close()
			set hidden = 1
			if(!client) return
			winshow(src, "welcome", 0)
			beep()

		alert_close()
			set hidden = 1
			alert_clicked = 1
			beep()

		input_close()
			set hidden = 1
			alert_answer = winget(src, "alert4.input", "text")
			beep()

		alert_yes()
			set hidden = 1
			alert_answer = "yes"
			beep()

		alert_no()
			set hidden = 1
			alert_answer = "no"
			beep()

	proc

		get_header(msg, big = 0)
			if(!big)
				switch(msg)
					if("Stranger description?")
						return "http://i.imgur.com/6wuVuTx.png"
					if("Alert")
						return "http://s1.postimg.org/sdg8yqvsv/Alert.png"
					if("Please select an option")
						return "http://s2.postimg.org/9uk74owbd/header_2.png"
					if("Which clan do you belong to?")
						return "http://s14.postimg.org/tt0by608x/header_3.png"
					if("Custom clan selection")
						return "http://s7.postimg.org/47fss6b4r/header_4.png"
					if("What will your family name be?")
						return "http://s13.postimg.org/lcc657yg7/What_will_your_family_name_be.png"
					if("Please enter your Age from 8-61.")
						return "http://s9.postimg.org/sh5twv5an/header_6.png"
					if("What will your name be?")
						return "http://s27.postimg.org/w5t3ejieb/header_5.png"
			else
				switch(msg)
					if("Would you like to be born as a member of the Uchiha clan?")
						return "http://s12.postimg.org/tnh9b4wel/Would_you_like_to_be_born_as_a_member_of_the_Uch.png"
					if("Would you like to be born as a member of the Hyuuga clan?")
						return "http://s1.postimg.org/9mz8tjckv/Would_you_like_to_be_born_as_a_member_of_the_Hyu.png"
					if("Would you like to be born as a member of the Inuzuka clan?")
						return "http://s28.postimg.org/wvsr7hh1p/Would_you_like_to_be_born_as_a_member_of_the_Inu.png"
					if("Would you like to be born as a member of the Aburame clan?")
						return "http://s1.postimg.org/h48g8r23z/Would_you_like_to_be_born_as_a_member_of_the_Abu.png"
					if("Would you like to be born as a member of the Akimichi clan?")
						return "http://s14.postimg.org/qwdaxvuf5/big_header_2.png"
					if("Would you like to be born as a member of the Senju clan?")
						return "http://s8.postimg.org/9laco5rc5/Would_you_like_to_be_born_as_a_member_of_the_Sen.png"
					if("Would you like to be born as a member of the Nara clan?")
						return "http://s8.postimg.org/c06d2yg11/big_header_4.png"
					if("Would you like to be born as a member of the Hozuki clan?")
						return "http://s17.postimg.org/6yyf1e8q7/Would_you_like_to_be_born_as_a_member_of_the_Hoz.png"
					if("Would you like to be born as a member of the Kaguya clan?")
						return "http://s12.postimg.org/4la4kk0lp/Would_you_like_to_be_born_as_a_member_of_the_Kag.png"
		custom_alert_html(msg, title = "Alert")
			if(!src.client) return

			var/pos = winget(src, "default.screenlabel", "size")
			var/xx = text2num(copytext(pos, 1, findtext(pos, "x", 1, length(pos) + 1)))
			var/yy = text2num(copytext(pos, findtext(pos, "x", 1, length(pos) + 1) + 1, length(pos) + 1))

			var/pos1 = winget(src, "default", "pos")
			var/xx1 = text2num(copytext(pos1, 1, findtext(pos1, ",", 1, length(pos1) + 1)))
			var/yy1 = text2num(copytext(pos1, findtext(pos1, ",", 1, length(pos1) + 1) + 1, length(pos1) + 1))

			winset(src, "alert_html", "pos=[(xx/2) - 115 + xx1],[yy1 + (yy/2) - 60]")

			src << output("[skin_tab["html"]]<img src=[get_header(title)]></body><html>", "alert_html.header")



			//winset(src, "alert_html", "size=227x[round(11 * ((length(msg) * 5) / 192) ) + 100]")
			src << output(null,"alert_html.text")
			src << output(msg, "alert_html.text")
			winshow(src, "alert_html", 1)
			alert_clicked = 0
			while(!alert_clicked)
				sleep(1)
			winshow(src, "alert_html", 0)
		custom_alert(msg, title = "Alert")
			if(!src.client) return

			var/pos = winget(src, "default.screenlabel", "size")
			var/xx = text2num(copytext(pos, 1, findtext(pos, "x", 1, length(pos) + 1)))
			var/yy = text2num(copytext(pos, findtext(pos, "x", 1, length(pos) + 1) + 1, length(pos) + 1))

			var/pos1 = winget(src, "default", "pos")
			var/xx1 = text2num(copytext(pos1, 1, findtext(pos1, ",", 1, length(pos1) + 1)))
			var/yy1 = text2num(copytext(pos1, findtext(pos1, ",", 1, length(pos1) + 1) + 1, length(pos1) + 1))

			winset(src, "alert", "pos=[(xx/2) - 115 + xx1],[yy1 + (yy/2) - 60]")

			src << output("[skin_tab["html"]]<img src=[get_header(title)]></body><html>", "alert.header")



			winset(src, "alert", "size=227x[round(11 * ((length(msg) * 5) / 192) ) + 100]")

			src << output(msg, "alert.text")
			winshow(src, "alert", 1)
			alert_clicked = 0
			while(!alert_clicked)
				sleep(1)
			winshow(src, "alert", 0)

		custom_alert2(msg, title = "Alert")
			if(!src.client) return

			var/pos = winget(src, "default.screenlabel", "size")
			var/xx = text2num(copytext(pos, 1, findtext(pos, "x", 1, length(pos) + 1)))
			var/yy = text2num(copytext(pos, findtext(pos, "x", 1, length(pos) + 1) + 1, length(pos) + 1))

			var/pos1 = winget(src, "default", "pos")
			var/xx1 = text2num(copytext(pos1, 1, findtext(pos1, ",", 1, length(pos1) + 1)))
			var/yy1 = text2num(copytext(pos1, findtext(pos1, ",", 1, length(pos1) + 1) + 1, length(pos1) + 1))

			src << output("[skin_tab["html"]]<img src=[get_header(title)]></body><html>", "alert2.header")

			winset(src, "alert2", "pos=[(xx/2) - 115 + xx1],[yy1 + (yy/2) - 60]")

			winset(src, "alert2", "size=227x[round(11 * ((length(msg) * 5) / 192) ) + 100]")

			src << output(msg, "alert2.text")
			winshow(src, "alert2", 1)
			alert_answer = null
			while(!alert_answer)
				sleep(1)
			winshow(src, "alert2", 0)
			return alert_answer

		custom_alert3(var/list/grid_list, title = "Alert")
			if(!src.client) return
			var/pos = winget(src, "default.screenlabel", "size")
			var/xx = text2num(copytext(pos, 1, findtext(pos, "x", 1, length(pos) + 1)))
			var/yy = text2num(copytext(pos, findtext(pos, "x", 1, length(pos) + 1) + 1, length(pos) + 1))

			var/pos1 = winget(src, "default", "pos")
			var/xx1 = text2num(copytext(pos1, 1, findtext(pos1, ",", 1, length(pos1) + 1)))
			var/yy1 = text2num(copytext(pos1, findtext(pos1, ",", 1, length(pos1) + 1) + 1, length(pos1) + 1))

			src << output("[skin_tab["html"]]<img src=[get_header(title)]></body><html>", "alert3.header")

			winset(src, "alert3", "pos=[(xx/2) - 115 + xx1],[yy1 + (yy/2) - 60]")

			winset(src, "alert3", "size=227x[min((20 * grid_list.len) + 60, 350)]")
			winset(src, "alert3.grid", "cells=1x[grid_list.len]")
			winset(usr, "alert3.grid", {"style="body {color:#FFFDCA;}""})
			var/row = 1

			for(var/t in grid_list)
				var/obj/grid_object/g = new(src)
				g.name = t
				g.real_name = t
				g.row = row
				src << output(g, "alert3.grid:[row]")
				row++

			winshow(src, "alert3", 1)
			alert_answer = null
			while(!alert_answer)
				sleep(1)
			for(var/obj/grid_object/g in src)
				del(g)
			winshow(src, "alert3", 0)
			return alert_answer

		custom_alert4(title = "Alert")
			if(!src.client) return
			var/pos = winget(src, "default.screenlabel", "size")
			var/xx = text2num(copytext(pos, 1, findtext(pos, "x", 1, length(pos) + 1)))
			var/yy = text2num(copytext(pos, findtext(pos, "x", 1, length(pos) + 1) + 1, length(pos) + 1))

			var/pos1 = winget(src, "default", "pos")
			var/xx1 = text2num(copytext(pos1, 1, findtext(pos1, ",", 1, length(pos1) + 1)))
			var/yy1 = text2num(copytext(pos1, findtext(pos1, ",", 1, length(pos1) + 1) + 1, length(pos1) + 1))

			src << output("[skin_tab["html"]]<img src=[get_header(title)]></body><html>", "alert4.header")

			winset(src, "alert4.input", "text=''")

			winset(src, "alert4", "pos=[(xx/2) - 150 + xx1],[yy1 + (yy/2) - 60]")

			winshow(src, "alert4", 1)
			alert_answer = null
			while(!alert_answer)
				sleep(1)
			winshow(src, "alert4", 0)
			return alert_answer

		custom_bigalert1(msg, msg2, file, title = "Alert")
			if(!src.client) return

			var/pos = winget(src, "default.screenlabel", "size")
			var/xx = text2num(copytext(pos, 1, findtext(pos, "x", 1, length(pos) + 1)))
			var/yy = text2num(copytext(pos, findtext(pos, "x", 1, length(pos) + 1) + 1, length(pos) + 1))

			var/pos1 = winget(src, "default", "pos")
			var/xx1 = text2num(copytext(pos1, 1, findtext(pos1, ",", 1, length(pos1) + 1)))
			var/yy1 = text2num(copytext(pos1, findtext(pos1, ",", 1, length(pos1) + 1) + 1, length(pos1) + 1))

			src << output("[skin_tab["html"]]<img src=[get_header(title, 1)]></body><html>", "bigalert1.header")

			winset(src, "bigalert1", "pos=[(xx/2) - 268 + xx1],[yy1 + (yy/2) - 165]")

			//winset(src, "bigalert1", "size=536x[round(11 * ((length(msg) * 5) / 500) ) + 100]")

			src << output("[msg]", "bigalert1.text")
			src << output("[msg2]", "bigalert1.text2")

			winset(src, "bigalert1.picture", "image='[file]'")

			winshow(src, "bigalert1", 1)
			alert_answer = null
			while(!alert_answer)
				sleep(1)
			winshow(src, "bigalert1", 0)
			return alert_answer

	var
		tmp/alert_answer
		tmp/alert_clicked
		tmp/alert_selected
		tmp/list/obj/grid_object/grid_objects = list()

/obj/grid_object
	mouse_over_pointer = MOUSE_HAND_POINTER
	var/real_name
	var/row

	MouseEntered()
		winset(usr, "alert3.grid", {"style="body {color:#E9C80D;}""})
		usr << output(src, "alert3.grid:1,[row]")

	MouseExited()
		winset(usr, "alert3.grid", {"style="body {color:#FFFDCA;}""})
		usr << output(src, "alert3.grid:1,[row]")

	Click()
		mouse_over_pointer = MOUSE_INACTIVE_POINTER
		usr.alert_answer = real_name
		usr.beep()
