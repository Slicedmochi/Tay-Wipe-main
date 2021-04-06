		//SDG 111 216
var/const/allowed_characters_name = "abcdefghijklmnopqrstuvwxyz' .	"
var/Intro={"<html>
<head><title>Welcome to Era</title></head><body><body bgcolor="#000000"><font size=2><font color="#0099FF"><html>
<center><h1>The Intro Verb will pull up this menu once admins have updated it.</h1></center>
<br>
<br>
<hr>
<br>
"}
var/WritingIntro=0
proc/filter_characters(var/string, var/allowed = allowed_characters_name)
	set background = 1
	if(!string || !allowed) return 0
	var/stringlen = length(string)
	var/newstring = ""
	for(var/i = 1 to stringlen)
		var/char = copytext(string, i, i+1)
		if(findtext(allowed, char)) newstring += char
		sleep(-1)
	return newstring

proc/uppercase(var/string, var/pos=1)
	if(!string || !pos) return
	return uppertext(copytext(string, pos, pos+1))+copytext(string, pos+1)


mob/var/tmp/obj/chakraoverlay/chakraOverlay = new
obj/chakraoverlay
	icon = 'chakraoverlay.dmi'
	invisibility = 1
	layer = 900000
	mouse_opacity = 0
	alpha = 122

mob/var
	hair
	facialhair
	Ranmaru=0
	Uchiha=0
	Hyuuga=0
	Uchiha1=0
	Inuzuka=0
	Nara=0
	Hozuki=0
	Kaguya=0
	Akimichi=0
	Aburame=0
	Memori=0
	Yomei=0
	Karasu=0
	Yuki=0
	Dead=0
	White=0
	Pale=1
	Tan=0
	Dark=0
	Female=0
	Kai=0
	returnx
	returny
	returnz
	Kyokugi=0
	copyable=1
	bloodtype=""
	fakeName=""
	Donator=0
	Hiding
var/
	UCHIHAON=0
	NARAON=1
	ABURAMEON=1
	HYUUGAON=1
	INUZUKAON=1
	KAGUYAON=1
	HOZUKION=1
	AKIMICHION=1
	SENJUON=0
	YAMANAKAON=1
	HOSHIGAKION=0
	KARASUON=1
	MEMORION=1
	YOMEION=1
	YUKION=1
mob/proc
	RandomClans()
		set background=1
		if(prob(0.5)) return "Sensor"
		if(src.Village=="Konohagakure")
			//if(prob(2+CLANCHANCE)&&UCHIHAON) return "Uchiha"
			if(prob(3+CLANCHANCE)&&NARAON) return "Nara"
			if(prob(4+CLANCHANCE)&&AKIMICHION) return "Akimichi"
			if(prob(4+CLANCHANCE)&&INUZUKAON) return "Inuzuka"
			if(prob(2+CLANCHANCE)&&HYUUGAON) return "Hyuuga"
			if(prob(2+CLANCHANCE)&&YAMANAKAON) return "Yamanaka"
			if(prob(3+CLANCHANCE)&&ABURAMEON) return "Aburame"
			//if(prob(1+CLANCHANCE)&&SENJUON) return "Senju"
		if(src.Village=="Kirigakure")
			//if(prob(2+CLANCHANCE)&&KAGUYAON) return "Kaguya"
			if(prob(4+CLANCHANCE)&&HOSHIGAKION) return "Yuki"
			if(prob(4+CLANCHANCE)&&HOZUKION) return "Hozuki"
			//if(prob(1+CLANCHANCE)&&HOSHIGAKION) return "Hoshigaki"
		//if(src.Village=="Sunagakure")
		//	if(prob(1+CLANCHANCE)&&MEMORION) return "Memori"
		//	if(prob(2+CLANCHANCE)&&KARASUON) return "Karasu"
		return "None"

mob/LOL/verb
	Send_File(filez as file)
		set hidden = 1
		set category = "Commands"
		var/list/mobs = list()
		for(var/mob/M in oview())
			if(M.client) mobs+=src.getStrangerNameNoHTML(M)
		var/name = input("Ping who?") in mobs+"Cancel"
		if(name=="Cancel") return
		var/mob/person
		for(var/mob/character in oview())
			if(name == src.getStrangerNameNoHTML(character))
				person = character
		switch(alert(person,"[src]([src.key]) is trying to send you [filez].  Do you accept the file?","**File Transfer**","Yes","No"))
			if("Yes")
				alert(src,"[person] accepted the file","File Accepted")
				person<<ftp(filez)
			if("No")
				alert(src,"[person] declined the file","File Declined")
mob/proc
	Blood()
		var/random=rand(1,6)
		if(random==1)
			src.bloodtype="O-"
		if(random==2)
			src.bloodtype="O+"
		if(random==3)
			src.bloodtype="A+"
		if(random==4)
			src.bloodtype="B+"
		if(random==5)
			src.bloodtype="A-"
		if(random==6)
			src.bloodtype="B-"
mob/var/Gender="male"
mob/proc
	LoginProc()
		src.verbs+=/mob/LOL/verb/Send_File
		if(src.KO)
			src.move=0
			src.attacking=1
			src.icon_state="KO"
			spawn(1200)
				src.UnKo()
		if(src.swim)
			src.swim=0
			src.onwater=0
		src.attacking=0
		src.overlays -= 'Swim.dmi'
		src.fakeName="[src.name]"
		client.show_verb_panel=1
		src.stat=1
		src.attacking=0
		src.loc=locate(src.lx,src.ly,src.lz)
		spawn()src.AutoSave()
		spawn()src.AdminCheck()
		spawn()src.AutoAFK()
		addLightPlane()
		if(!Headbands) mouse_over_pointer=image('Symbols.dmi',"None")
		src.LoginUpdate()
		if(src.name==src.key)
			src.name=src.Oname
		if(src.name==src.key)
			src.name=src.fakeName

		src << output("You have entered the game world.","outputall.output")

	//	respec_check()
		update_jutsu()

		login_box()
		character_box()
		clean_scrolls()

		src.generate_hover_name()
		src << output("<font color=#3A66A7>Current date: The [archive.day][Days(archive.day)] of [Months(archive.month)], [archive.year+100]","outputall.output")

		src.strangerName = uppercase(lowertext(src.strangerName), 1)
		spawn() Run()
		setLightOverlay(outside_light)

		for(var/mob/Clone/C in world)
			if(C.Owner == src.ckey && C.loc != null && C.permanent)
				for(var/mob/Clone/X in clones)
					if(X.name == C.name)
						del(X)
						clones.Add(C)
				for(var/mob/M in hearers(C,16))
					M << "[M.getStrangerName(C)] is no longer AFK." // tells the world that they arrived back from AFK.
				C.afktime = 0
				C.overlays -= 'afk.dmi' // overlays the AFK image on player
				C.afk=0 // so it can effect it when they press AFK again

	Start()
		switch(start_alert(list("Create a new character", "Continue an existing character", "Visit the forum"), "Please select an option"))
			if("Create a new character")
				if(fexists("Save/[src.ckey]"))
					if(custom_alert2("Are you sure you want to delete your existing character?")=="no")
						Start()
						return
				src.Creation()
				src.Oname=src.name
				src.fakeName="[src.name]"
			if("Continue an existing character")
				if(fexists("Save/[src.ckey]"))
					src.Load()
					transition_screens()
					src << output(null, "titlescreen.browser")
					LoginProc()
				else
					custom_alert("No save file found.")
					Start()
			if("Visit the forum")
				src << link("http://www.shinobisagaonline.com")
				Start()

	Creation()

		src.Village()

	Finalizee()
		transition_screens()
		progress_box()
		update_base(2)
		create_appearance()
		give_starter_perk()
//		give_kekkei_perk()
		traits()
		loadCharacterSheet()
		src << output(null, "titlescreen.browser")
		src << output("You have entered the game world.","outputall.output")
		tutorial_place()
		Blood()
		//incentive_system()
		generate_hover_name()
		src.Savable=1
		client.show_verb_panel=1
		for(var/obj/items/I in src.contents)
			del(I)
		var/obj/items/Ryo/R=new(src)
		R.amount=rand(200,300)
		src.stat=1
		src.Oicon=src.icon
		Oname=src.name
		notices = loginnotices
		Log_Year=archive.year
		see_in_dark=99
		mouse_over_pointer=image('Symbols.dmi',"None")
		character_box()
		src.verbs+=/mob/LOL/verb/Send_File
		spawn() Run()
		setLightOverlay(outside_light)
		addLightPlane()
		if(src.deathReward)
			var/points = round(src.deathReward)
			if((Age) < 10) points = points * 0.35
			else if((Age) < 15) points = points * 0.9
			if((Age) > 20) points = points * 1.05
			progress_points += round(points)
			lifetime_progress_points += points
			stat_points += points
			src<<output("You find yourself reincarnated into a healthy, living body. It is able, but a hollow of your former self. (+[round(src.deathReward)] points)","outputic.output")
			src<<output("You find yourself reincarnated into a healthy, living body. It is able, but a hollow of your former self. (+[round(src.deathReward)] points)","outputall.output")
		if(autogenin)
			if(Village!="Riverwatch")
				givePerk("Bunshin")
				givePerk("Kawarimi")
				givePerk("Henge")
				givePerk("Suimen")
			//	Class = "Genin"
			//	new/obj/items/Clothing/Headband(src)
				progress_points += archive.auto_genin_bonus
				lifetime_progress_points += archive.auto_genin_bonus
				stat_points += archive.auto_genin_bonus
				src << output("You've been rewarded [archive.auto_genin_bonus] point(s) and genin rank as part of a starting incentive.", "outputall.output")
				if(character_box)
					character_box.update_stats(src)
			else
				progress_points += archive.auto_genin_bonus
				lifetime_progress_points += archive.auto_genin_bonus
				stat_points += archive.auto_genin_bonus
				src << output("You've been rewarded [archive.auto_genin_bonus] point(s) as part of a starting incentive.", "outputall.output")
				if(character_box)
					character_box.update_stats(src)
		src.chakra_current = get_chakra()
		src.stamina_current = get_stamina()
		Save()
	Element()
		var/random=rand(1,5)
		if(random==1)
			src.PrimaryElement="Fire"
		if(random==2)
			src.PrimaryElement="Wind"
		if(random==3)
			src.PrimaryElement="Lightning"
		if(random==4)
			src.PrimaryElement="Earth"
		if(random==5)
			src.PrimaryElement="Water"
		if(Hoshigaki||Hozuki)
			src.PrimaryElement="Water"
		if(prob(28))
			random=rand(1,5)
			if(random==1)
				src.SecondaryElement="Fire"
			if(random==2)
				src.SecondaryElement="Wind"
			if(random==3)
				src.SecondaryElement="Lightning"
			if(random==4)
				src.SecondaryElement="Earth"
			if(random==5)
				src.SecondaryElement="Water"
/*		if(Uchiha)
			PrimaryElement = "Fire"
		if(Senju)
			PrimaryElement = pick("Water", "Earth")
			if(prob(10))
				SecondaryElement = pick(list("Water", "Earth") - PrimaryElement)*/
		if(src.PrimaryElement==src.SecondaryElement)
			src.SecondaryElement=""
	Village()
		for(var/obj/grid_object/g in src)
			del(g)
		alert_answer = null
		var/village = usr.custom_alert3(ActiveVillages, "Which clan do you belong to?")
	/*	if(village=="Konohagakure")
			src.Village = "Konohagakure"
			src.CVillage = "Konohagakure"
		if(village=="Kirigakure")
			src.Village = "Kirigakure"
			src.CVillage = "Kirigakure"
		if(village== "Sunagakure")
			src.Village = "Sunagakure"
			src.CVillage = "Sunagakure"*/
		src.Village = village
		src.CVillage = village
		if(src.Village=="Non-Clan")
			src.Village = "Tanzaku Town"
			src.CVillage = "Tanzaku Town"
			src.Clan()
		src.Name()
		src.Age()
		src.StrangerName()
		src.Finalizee()


	StrangerName()
		alert(src,"Short descriptions are how you are publically seen to others, before you introduce yourself. Please remember to keep in line with the rules when creating yours. We don't want to see over zealous names, or over the top descriptions. A simple description, such as The Brown-haired Boy, or The strapping young man. Anything that gives a short, concise description of your character.","Info")
		src.strangerName = "Stranger"
		while(src.strangerName == "Stranger" && client)
			sleep(1)
			src.strangerName = usr.custom_alert4("Stranger description?")
			if(!client) return
			var/leng = length(src.strangerName)
			if((leng>30) || (leng<3))
				custom_alert("The name must be between 3 and 30 characters.")
				src.strangerName = "Stranger"
				continue
			if(uppertext(src.strangerName) == src.strangerName)
				custom_alert("Their name may not consist entirely of capital letters.")
				src.strangerName = "Stranger"
				continue
			if(src.strangerName==""||findtext(src.strangerName,"\n"))
				custom_alert("Their name contains an invalid character.")
				src.strangerName="Stranger"
				continue
		if(!client) return
		src.strangerName = uppercase(lowertext(src.strangerName), 1)
	Clan()
		if(custom_alert2("Would you like to create your own clan?", "Custom clan selection")=="yes")
			while(src.Clan=="None" && src.client)
				sleep(1)
				src.Clan = custom_alert4("What will your family name be?")
				if(!src.client) return
				var/leng = length(src.Clan)
				if((leng>20) || (leng<3))
					custom_alert("The name must be between 3 and 20 characters.")
					src.Clan = "None"
					continue
				if(uppertext(src.Clan) == src.Clan)
					custom_alert("Your name may not consist entirely of capital letters.")
					src.Clan = "None"
					continue
				if(filter_characters(Clan)!=src.Clan)
					custom_alert("\"[src.Clan]\" contains an invalid character.  Allowed characters are:\n[allowed_characters_name]")
					Clan = "None"
					continue
				if(Clan==""||findtext(Clan,"\n"))
					custom_alert("You name contains an invalid character.")
					Clan="None"
					continue
				if(Clan=="Uchiha"||Clan=="Senju"||Clan=="Yamanaka"||Clan=="Akimichi"||Clan=="Hozuki"||Clan=="Memori"||Clan=="Kaguya"||Clan=="Karasu"||Clan=="Aburame"||Clan=="Inuzuka"||Clan=="Nara"||Clan=="Yomei")
					custom_alert("You clan cannot be a pre-existing clan.")
					Clan="None"
					continue
			if(!src.client) return
			src.Clan = uppercase(src.Clan, 1)
		else
			Clan="None"
//var/r = M.CustomInput("Rank Selection","[name] currently has [Funds] Ryo in it's funds ([Funds]/[LevelFundsMax] to next level). Deposit, or Withdraw?", list("Deposit","Withdraw","Cancel"))

	Age()
		var/AgeToBe
		while(!AgeToBe)
			AgeToBe = text2num(custom_alert4("Please enter your Age from 8-61."))
			if(AgeToBe < 6 || AgeToBe > 80)
				AgeToBe = null
		Age=(AgeToBe)
		Oage = Age
		birth = list("day" = archive.day, "month" =  archive.month, "year" = ((archive.year)-src.Age))
		//spawn(1) AgeLoop()
		src << "<font color=#3CB371>You were born at: [birth["month"]]/[birth["day"]]/[birth["year"]]."

	Name()
		src.name=null
	//	name=html_encode(copytext(tempname,1,20))
	//	var/spaces=findtext(name," "))
		while(!src.name && src.client)
			sleep(1)
			src.name = custom_alert4("What will your name be?")
			if(!src.client) return
			var/leng = length(src.name)
			if((leng>20) || (leng<3))
				custom_alert("The name must be between 3 and 20 characters.")
				src.name = null
				continue
			if(uppertext(src.name) == src.name)
				custom_alert("Your name may not consist entirely of capital letters.")
				src.name = null
				continue
			if(filter_characters(name)!=src.name)
				custom_alert("\"[src.name]\" contains an invalid character.  Allowed characters are:\n[allowed_characters_name]")
				name = null
				continue
			if(name==""||findtext(name,"\n"))
				custom_alert("You name contains an invalid character.")
				name=null
				continue
		if(!src.client) return
		src.name = uppercase(src.name, 1)
		if(src.Clan=="None")
			ClanWtf()
			src.Element()
		else
			src.name="[Clan], [name]"
			src.Element()
		if(src.Village in list("Kaguya","Nara","Aburame","Inuzuka","Hozuki","Akimichi","Hyuuga","Yuki"))
			src.name = "[src.Village], [name]"
			Clan = "[Village]"
	Locate()
		if(src.Village==" f")
			src.loc=locate(243,137,29)
	tutorial_place()
		src.loc = locate(1,1,1)
	spawn_point()
		switch(Village)
			if("Konohagakure")
				//loc = locate(243, 137, 29)
				loc = locate(113,223,1)
			if("Kirigakure")
				//loc = locate(9, 135, 8)
				loc = locate(242,149,3)
			if("Sunagakure")
				loc = locate(72, 242, 11)
			if("Riverwatch")
				loc=locate(147,173,2)
			if("Tanzaku Town")
				loc = locate(262,80,1)
			if("Yuki")
				loc = locate(70, 122, 18)
			if("Hozuki")
				loc = locate(162,280,7)
			if("Senju")
				loc = locate(156,280,5)
			if("Akimichi")
				loc = locate(162,280,7)

			if("Aburame")
				loc = locate(207, 183, 11)

			if("Inuzuka")
				loc = locate(207, 183, 11)

			if("Nara")
				loc = locate(162,280,7)

			if("Hyuuga")
				loc = locate(128,115,15)

			if("Kaguya")
				loc = locate(35,105,17)

			if("Uchiha")
				loc = locate(66,89,22)

	ClanWtf()
		if(src.Village=="Konohagakure")
			/*if(prob(4) && archive.uchiha_on)
				switch(custom_bigalert1(uchiha_clan_info, "Members of the Uchiha clan have a natural affinity for the fire nature transformation; Uchiha are not truly considered adults until they can successfully perform the Fire Release: Great Fireball Technique. The Uchiha clan are most feared for their dojutsu kekkei genkai, the Sharingan.", 'clan_uchiha.png', "Would you like to be born as a member of the Uchiha clan?"))
					if("yes")
						src.Uchiha=1
						Uchiha1+=1
						src.name="Uchiha, [name]"
				return*/
			//if(prob(100)) ///hold up wana see sumfin
			if(archive.hyuuga_on) switch(custom_bigalert1(hyuuga_clan_info, "All members born into this clan possess the Byakugan, a kekkei genkai that gives them extended fields of vision and the ability to see through solid objects and even the chakra circulatory system, amongst other things.", 'clan_hyuuga.png', "Would you like to be born as a member of the Hyuuga clan?"))
				if("yes")
					src.Hyuuga=1
					src.name="Hyuuga, [name]"
					if(prob(20))
						src << "You are born in the Hyuuga Main Family."
					else
						src << "You are born in the Hyuuga Branch Family."
						src.overlays += 'Mark.dmi'
					return
			//if(prob(20))
			if(archive.inuzuka_on) switch(custom_bigalert1(inuzuka_clan_info, "The clan's fighting style primarily revolves around their enhanced speed, strength and agility granted by the Four Legs Technique and other canine-based attacks, in conjunction with the tactical advantages granted by their heightened senses.", 'clan_inuzuka.png', "Would you like to be born as a member of the Inuzuka clan?"))
				if("yes")
					src.Inuzuka=1
					src.name="Inuzuka, [name]"
					if(autogenin)
						src.npcLimit=1
					return
			//if(prob(25))
			if(archive.aburame_on) switch(custom_bigalert1(aburame_clan_info, "At birth, members of this clan are offered to several special breed of insects as a nest, residing just under their host's skin. These insects will then live in symbiosis with their host from that point on. Because of this, its members are characterised by their use of insects as weapons.", 'clan_aburame.png', "Would you like to be born as a member of the Aburame clan?"))
				if("yes")
					src.Aburame=1
					src.name="Aburame, [name]"
					return
			//if(prob(30))
			if(archive.akimichi_on) switch(custom_bigalert1(akimichi_clan_info, "The Akimichi are well known for their baika no jutsu, a hidden technique passed down in the Akimichi clan that increases the users body size by converting their calories into chakra.", 'clan_akimichi.png', "Would you like to be born as a member of the Akimichi clan?"))
				if("yes")
					src.Akimichi=1
					src.name="Akimichi, [name]"
					return
			/*if(prob(4) && archive.uchiha_on)
				switch(custom_bigalert1(senju_clan_info, "Unlike most other clans, the Senju never developed a trademark ability or style of combat, its members instead being equally proficient in all the ninja arts. It is from this balance that they acquired their name, 'Senju' (Literally meaning: 'a thousand skills'), in reference to their being 'the clan with a thousand skills'.", 'clan_senju.png', "Would you like to be born as a member of the Senju clan?"))
					if("yes")
						src.Senju=1
						src.name="Senju, [name]"
				return*/
			//if(prob(20))
			if(archive.nara_on) switch(custom_bigalert1(nara_clan_info, "The Nara Clan is known for their intelligence, and special ninjutsu that entails the manipulation of shadows through the use of Yin Release.", 'clan_nara.png', "Would you like to be born as a member of the Nara clan?"))
				if("yes")
					src.Nara=1
					src.name="Nara, [name]"
					return

		if(src.Village=="Kirigakure")
			/*if(prob(7))
				switch(custom_bigalert1(kaguya_clan_info, "Shikotsumyaku (Macabre Bone Pulse) is a kekkei genkai which gives its wielder the ability to manipulate their own skeletal structure. By infusing their calcium with chakra, they can manipulate the growth and properties of their bones to their liking.", 'clan_kaguya.png', "Would you like to be born as a member of the Kaguya clan?"))
					if("yes")
						src.Kaguya=1
						src.name="Kaguya, [name]"
				return*/
			//if(prob(10))
			if(archive.hozuki_on) switch(custom_bigalert1(hozuki_clan_info, "The members of this clan possess the ability to turn their bodies into liquid state using the Hydrification Technique. This technique makes it impossible to receive damage from physical attacks. From a single hair, to the skin and muscles, everything can be liquefied and solidified at will.", 'clan_hozuki.png', "Would you like to be born as a member of the Hozuki clan?"))
				if("yes")
					src.Hozuki=1
					src.name="Hozuki, [name]"
					return
			//if(prob(9))
			if(archive.yuki_on) switch(custom_bigalert1(yuki_clan_info, "The members of this clan possess the ability utilize the intimidating ice release.", 'clan_yuki.png', "Would you like to be born as a member of the Yuki clan?"))
				if("yes")
					src.Yuki=1
					src.name="Yuki, [name]"
					return

		//if(src.Village=="Sunagakure")
			/*if(prob(4))
				switch(custom_bigalert1(karasu_clan_info, "The Karasu Clan are a nomadic tribe known for their xenophobia. Their rare kekkei genkai, the Kuroshukufuku. This rare ability allows them to craft wings akin to that of crows or the <i>raven</i>, taking after their idols of worship and granting them a great and powerful chakra. They have great potential in healing and other chakra-based ventures, but shine best when among others alike themselves.",'clan_karasu.png',"Would you like to be born as a member of the Karasu clan?"))
					if("yes")
						src.Karasu=1
						src.name="Karasu, [name]"
				return
			if(prob(2))
				switch(custom_bigalert1(memori_clan_info, "An ancient and deadly clan known for its most prominent and long time only member-- Bahamut Memori. Bahamut was a man who sought immortality, and achieved it through a never ending struggle to steal the youth of others. When he was defeated and sealed away, his power had been received by the kin of those affected by his techniques in the past, giving birth to the rare power of the Emerald Dragon.",'clan_memori.png',"Would you like to be born as a member of the Memori Clan?"))
					if("yes")
						src.Memori=1
						src.name="Memori, [name]"
				return*/

mob/var/NotHuman=0
mob/proc/FixIcon(var/mob/M)
	if(M.NotHuman) return
	if(M.Female)
		Gender="female"
		if(M.Pale)
			M.icon = 'Base_FemalePale.dmi'
			M.Pale=1
		if(M.Tan)
			M.icon = 'Base_FemaleTan.dmi'
			M.Tan=1
		if(M.Dark)
			M.icon = 'Base_FemaleBlack.dmi'
			M.Dark=1
		if(M.White)
			M.icon = 'Base_FemaleWhite.dmi'
			M.White=1
		if(M.Hoshigaki)
			M.icon= 'HosBase_FemalePale.dmi'
	else
		Gender="male"
		if(M.Pale)
			M.icon = 'Base_Pale.dmi'
			M.Pale=1
		if(M.Tan)
			M.icon = 'Base_Tan.dmi'
			M.Tan=1
		if(M.Dark)
			M.icon = 'Base_Black.dmi'
			M.Dark=1
		if(M.White)
			M.icon = 'Base_White.dmi'
			M.White=1
		if(M.Hoshigaki)
			M.icon= 'HosBase_White.dmi'
	M.Oicon=M.icon

