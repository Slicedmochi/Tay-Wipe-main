var/daytime="Day"
area/var/Weather="Clear"

#define RENDER_WEATHER 1

var/tmp
	list/temperate_turfs= list()
	list/arid_turfs= list()
	list/tropical_turfs= list()
	list/frozen_turfs= list()

	climates = list("temperate" = null,"arid" = null,"tropical" = null,"frozen" = null)
area
	mouse_opacity=0
	Caves
		luminosity=0
	Interior
		layer = 1
		luminosity=1
		NoShunshin
			luminosity=1
		New()
			..()
			layer = 99
	AlwaysLit
	Exterior
		layer				= EFFECTS_LAYER
		appearance_flags	= NO_CLIENT_COLOR
		New()
			..()
			switch(Climate)
				if("Temperate")
					for(var/turf/t in contents)
						temperate_turfs += t
				if("Arid")
					for(var/turf/t in contents)
						arid_turfs += t
				if("Tropical")
					for(var/turf/t in contents)
						tropical_turfs += t
				if("Frozen")
					for(var/turf/t in contents)
						frozen_turfs += t
			del src
		var/Climate="Temperate"
		SunaDesert
			Climate="Arid"
		KiriOutside
			Climate="Tropical"
		SnowOutside
			Climate="Frozen"
proc
	Weather()
		set waitfor = 0
		var/timer = 0
		while(world)
			if(!RENDER_WEATHER) return
			sleep world.tick_lag
			timer++
			if(timer >= rand(10000,20000))
				var/biome = pick(climates)
				if(climates[biome]!=null) climates[biome] = null
				climates[biome] = pick("rain")
			if(temperate_turfs.len && climates["temperate"] != null) weather_start("temperate")
			if(arid_turfs.len && climates["arid"] != null) weather_start("arid")
			if(tropical_turfs.len && climates["tropical"] != null) weather_start("tropical")
			if(frozen_turfs.len && climates["frozen"] != null) weather_start("frozen")
	weather_start(var/biome)
		set waitfor = 0
		var/list/weather_tiles = list()
		var/list/players_outside = list()
		switch(biome)
			if("temperate") weather_tiles = temperate_turfs.Copy()
			if("arid") weather_tiles = arid_turfs.Copy()
			if("tropical") weather_tiles = tropical_turfs.Copy()
			if("frozen") weather_tiles = frozen_turfs.Copy()
		for(var/mob/M)										// an empty for() loop is faster than a while().
			if(climates[biome] == null) return
			if(!M.client) continue
			if(M.loc in weather_tiles)
				players_outside += M
		for(var/mob/M in players_outside)
			if(istype(M.loc,/area/Interior) || istype(M.loc,/area/Caves))
				players_outside -= M
				continue
			var/turf/t	= pick(block(locate(M.x-15,M.y-15,M.z),locate(M.x+15,M.y+15,M.z)))
			t.weather_effect(biome)
			sleep 0.1

turf
	proc
		weather_effect(var/biome)
			var/obj/weather/r 	= new /obj/weather/rain	// I use object pooling instead of calling new.. I suggest you do the same!
			r.loc 				= src
			animate(r,icon_state = "[climates[biome]]", pixel_y = 400, pixel_x = 0, alpha = 155, loop = 1)
			animate(pixel_y	= 5, pixel_x = pick(-10,10), time = 10.8)
			animate(icon_state = "[climates[biome]]land", time = rand(1.2, 4.8))
			spawn(17) del r								// again, I'd recollect the rain for recycling instead of deleting it.


obj/weather
	icon	= 'x16.dmi'
	layer	= EFFECTS_LAYER+11
	rain
		icon_state	= "rain"

// 365 days in the span of 7 days
// 6,048,000 in time
// 16,570 each sleep 
// about 27 n a half minutes each
archive
	var/day = 1
	var/month = 1
	var/year = 123
	var/BasePay = 100
	proc/DayLoop()
		while(1)
			sleep(16570)
			TriggerDay()
	proc/TriggerDay()
		day++
		CheckYear()
		world<<"<font size=-1>Current date is the [day][Days(day)] of [Months(month)] in the year [year]"
	proc/CheckYear()
		if(day>=31)
			day=1
			month++
			PayRoll()
		if(month>=12)
			month=1
			year++
			Age()
	proc/PayRoll()
		for(var/mob/x in ListOfPlayers())
			x.GetPaid()
	proc/IncreaseAge()
		for(var/mob/x in ListOfPlayers())
			x.AgeUp()
/mob/proc/AgeUp()
	if(istext(Age))
		Age=text2num(Age)
	Age++
	src<<"You're now [lowertext(AgeReturn(Age))] years old"
/mob/var/PayBoost
/mob/proc/GetPaid()
	var/AlteredPay = archive.BasePay + PayBoost
	give_ryo(AlteredPay)
	_output("Your check has been sent to you with a sum of $[AlteredPay] Ryo!", "selfalert","outputall.output")
	// faction check if anything is boosting there beause apparently like 12+ things can alter pay?
	//territory can change pay, buildings can change pay
//DayLoop
	//TriggerDay
		//YearCheck
			//Age
			//Payment
				//GetPaid
mob/Admin2/verb/
	start_weather()
		set category="Admin"
		var/biome = lowertext(input("Which biome?") in list("Temperate","Tropical","Arid","Frozen"))
		var/weather = lowertext(input("Which weather type") in list("Rain"))
		climates[biome] = weather
		weather_start(biome)
mob
	see_in_dark=99
proc/Days(var/num)
	var/stringnum=num2text(num)
	if(findtext(stringnum,"1")&&length(stringnum)==1) return "st"
	if(findtext(stringnum,"2")&&length(stringnum)==1) return "nd"
	if(findtext(stringnum,"3")&&length(stringnum)==1) return "rd"
	if(findtext(stringnum,"1",2)&&length(stringnum)==2&&stringnum!="11"&&stringnum!="12"&&stringnum!="13") return "st"
	if(findtext(stringnum,"2",2)&&length(stringnum)==2&&stringnum!="11"&&stringnum!="12"&&stringnum!="13") return "nd"
	if(findtext(stringnum,"3",2)&&length(stringnum)==2&&stringnum!="11"&&stringnum!="12"&&stringnum!="13") return "rd"
	return "th"
proc/Months(var/num)
	if(num==1) return "January"
	if(num==2) return "February"
	if(num==3) return "March"
	if(num==4) return "April"
	if(num==5) return "May"
	if(num==6) return "June"
	if(num==7) return "July"
	if(num==8) return "August"
	if(num==9) return "September"
	if(num==10) return "October"
	if(num==11) return "November"
	if(num==12) return "December"