/********************************************/
/******** Coded by jOrDaN Nov-Jan 2020 ********/
/********************************************/
//Hiding Verb, unfinished atm
/obj/jutsu/var/InvisAble = 0 
/mob/var/tmp/image/Invs = null
/mob/proc/CheckForInvs()
	var/obj/jutsu/jutsus = list()
	for(var/obj/jutsu/jutsu in src.contents)
		if(jutsu.InvisAble)
			jutsus += jutsu
	if(length(jutsus) < 1 ) return FALSE
	else return jutsus
/mob/verb/Hide()
	set category = "Combat Testing"
	if(!incombat) return
	var/obj/jutsu/jutsu = input(src, "What Jutsu do you want to use to hide?", "Hide") in CheckForInvs()
	invisibility = jutsu.InvisAble
	Invs = image(src.icon, src)
	Invs.appearance = src.appearance
	src<<Invs
/mob/verb/Reveal()
	set category = "Combat Testing"
	switch((input(src, "Do you want to reveal to everyone?") in list("Yes", "No")))
		if("Yes")
			invisibility = 0
			_output("has revealed themselves.", "oocalert", "outputall.output")
			AIHandler.RevealAllAI(key)
		if("No")
			var/mob/b = FindPerson(input(src, "Who do you want to see you?") in SortPeople(inView(TRUE)) + "Cancel")
			if(!b) return
			b<<Invs
			AIHandler.RevealAllAIToPerson(key, b)
			_output("has revealed themselves to [b.strangerName]", "oocalert", "outputall.output")
/mob/verb/MakeImageTest1()
	set category = "Combat Testing"
	var/image/I = new(null, src.loc)
	I.appearance = src.appearance
	src<<I
/mob/verb/MakeImageTest2()
	set category = "Combat Testing"
	var/image/A = new(src.appearance, src.loc)
	src<<A
/mob/verb/MakeImageTest3()
	set category = "Combat Testing"
	var/image/B = image(src.icon, src.loc)
	B.appearance = src.appearance
	src<<B
/mob/proc/EnableInvisibility(num) // num is equal to the level of invs, say dustless is 5, while hiding like a mole is 4, or hiding in mist is 1 or something.
//those with sensing or chakra sight will be able to detect those if chakra sight is allowed, so let us go deeper here                       
/*********************************************/
/*************** HANDSEALS ******************/
/********************************************/
/obj/jutsu/var/HSS = 0 // 1- 5
/mob/proc/CheckForHSS()
	var/obj/jutsu/jutsus = list()
	for(var/obj/jutsu/jutsu in src.contents)
		if(jutsu.HSS)
			jutsus += jutsu.HSS
	if(length(jutsus) < 1 ) return FALSE
	else return jutsus
/proc/ConvertHSS(list/handseals)
	var/list/hands = list("E")
	for(var/x in handseals)
		if(x > 0)
			hands += "D"
		if(x > 1)
			hands += "C"
		if(x > 2)
			hands += "B"
		if(x > 3)
			hands += "A"
		if(x > 4)
			hands += "S"
	return hands 
proc/get_grade_HSS(var/value = 0, var/stam = 0)
	if(value > 48) return "S+"
	if(value > 44) return "S"
	if(value > 41) return "S-"
	if(value > 38) return "A+"
	if(value > 35) return "A"
	if(value > 32) return "A-"
	if(value > 29) return "B+"
	if(value > 27) return "B"
	if(value > 23) return "B-"
	if(value > 20) return "C+"
	if(value > 17) return "C"
	if(value > 14) return "C-"
	if(value > 11) return "D+"
	if(value > 8) return "D"
	if(value > 5) return "D-"
	if(value > 2) return "E+"
	return "E"
proc/return_stat_HSS(var/value = "E")
	if(value == "S") return 45
	if(value == "A") return 36
	if(value == "B") return 27
	if(value == "C") return 18
	if(value == "D") return 9
	if(value == "E") return 0
	return 1
proc/calc_HSS(base, target)
	var/number = (base+3) - target
	return number
/mob/verb/Handseal()
	set category = "Combat"
	var/list/speeds = ConvertHSS(CheckForHSS()) // display to them their hss, 
	var/speed = input(src, "What handseal speed?", "Handseal Speed") in speeds
	var/amount = input(src, "How many handseals?", "How many?") as num
	if(amount > 99) return
	for(var/mob/M in hearers(16,src))
		M << output("<font size=1><font color=[src.SayFont]>[M.getStrangerName(src)] has completed [amount] handseals at <i><b>[get_grade_HSS(calc_HSS(return_stat_HSS(speed), amount))]</i></b> speed", "outputall.output")
// Speed
/proc/GradeToTileBuff(grade, mode)
	var/num
	var/statnumber = return_stat_grade(grade)
	switch(mode)
		if("walk")
			num = statnumber/30
		if("dodge")
			num = statnumber/20
		if("run")
			num = statnumber/10
	return num
//Make List of Grades
/proc/getGradesList(value)
	var/list/Letters = list()
	if(value > 133) Letters += "S"
	if(value > 123) Letters += "S"
	if(value > 109) Letters += "S-"
	if(value > 98) Letters += "A+"
	if(value > 87) Letters += "A"
	if(value > 77) Letters += "A-"
	if(value > 65) Letters += "B+"
	if(value > 55) Letters += "B"
	if(value > 46) Letters += "B-"
	if(value > 38) Letters += "C+"
	if(value > 31) Letters += "C"
	if(value > 25) Letters += "C-"
	if(value > 19) Letters += "D+"
	if(value > 13) Letters += "D"
	if(value > 9) Letters += "D-"
	if(value > 4) Letters += "E+"
	Letters += "E"
	return Letters
//Animating Stamina/Chakra bar, me thinks ? 
/mob/var/tmp/obj/staminabar/testingthing
/mob/verb/TestChakra()
	set category = "Debug"
	src<<get_grade_stat((src.control*0.7)+(src.stamina*0.3)+ chakra_boost_pool())
/obj/staminabar
	icon = 'Skin/newbarprog.dmi'
	proc/Adjust(f)
		var/animation_time = 2
		var/original_width = 1 // pixels of the icon itself
		var/full_width = 161
		var/fullness = f //M.Health.Value / (M.Health.Max + M.Health.Bonus)
		var/actual_width = full_width * fullness
		var/scale_x = actual_width / original_width
		var/scale_y = 1 // height unchanged
		var/offset_x = 12 + actual_width / 2
		var/offset_y = 0
		var/matrix/m = new
		m.Scale(scale_x, scale_y)
		m.Translate(offset_x, offset_y)
		animate(src, transform = m, time = animation_time)
/mob/var/list/combatstacks = list("Guard", "Dodge")
var/list/Letters2Num = list("E" = 0, "E+" = 1,"D-" = 2 , "D" = 3, "D+" = 4, "C-" = 5, "C" = 6, "C+" = 7, "B-" = 8,
					 "B" = 9, "B+" = 10, "A-" = 11, "A" = 12, "A+" = 13, "S-" = 14,
					 "S" = 15, "S+" = 16)
  /*******************************************/
 /*************** guard **************/
/*******************************************/// E = 1, everything after is plus 1
/mob/verb/GuardCalc()
	set category = "Calculator"
	if((input(src, "Is this a normal strike, or a technique?", "?") in list("Normal", "Technique")) == "Normal")
		GuardNormal()
	else
		GuardTech()
/mob/proc/GuardTech()
	var/guardvalue = input(src, "How much is your guard?", "?") in Letters2Num
	var/attackvalue = input(src, "How much is the damage?", "?") in Letters2Num
	var/value = Letters2Num[guardvalue] - Letters2Num[attackvalue]
	world<<value
	world<<isnum(value)
	if(value > -1)
		_output("You would take [Letters2Num[Letters2Num[attackvalue]-2]] damage, your guard is reduced by two.", "selfalert", "outputall.output")
	else if(value == 0)
		value+=2
		_output("You would take [Letters2Num[Letters2Num[attackvalue]-1]] damage, your guard is reduced by [value].", "selfalert", "outputall.output")
	else
		value = abs(value)+2
		_output("You would take [Letters2Num[Letters2Num[attackvalue]-1]] damage, your guard is reduced by [value] (Guard break).", "selfalert", "outputall.output")
/mob/proc/GuardNormal()
	var/guardvalue = input(src, "How much is your guard?", "?") in Letters2Num
	var/attackvalue = input(src, "How much is the damage?", "?") in Letters2Num
	var/value = (Letters2Num[guardvalue] - Letters2Num[attackvalue])
	world<<value
	if(value >= 3)
		_output("You would take no damage, but your guard is still reduced by 1.", "selfalert", "outputall.output")
	else if(value >= 1)
		_output("You would take [Letters2Num[Letters2Num[attackvalue]-2]] damage, your guard is reduced by one.", "selfalert", "outputall.output")
	else if(value >= -2)
		_output("You would take [Letters2Num[Letters2Num[attackvalue]-1]] damage, your guard is reduced by one.", "selfalert", "outputall.output")
	else if(value == -3)
		_output("You would take [Letters2Num[Letters2Num[attackvalue]-1]] damage, this breaks your guard.", "selfalert", "outputall.output")
	else if(value < -3)
		_output("You would take [Letters2Num[attackvalue]] damage, this breaks your guard.", "selfalert", "outputall.output")
/mob/verb/Guard()
	set category = "Combat"
	GuardStack(input(src, "What do you want to do with your guard?" , "Guard") in list("Add", "Subtract", "Reset", "Break"))
/mob/proc/GuardStack(var/command)
	switch(command)
		if("Add")
			combatstacks["Guard"]++
			_output("has dodged [combatstacks["Guard"]] times!", "oocalert", "outputall.output")
		if("Subtract")
			combatstacks["Guard"]--
			_output("has reduced their dodges to [combatstacks["Guard"]]", "oocalert", "outputall.output")
		if("Reset")
			combatstacks["Guard"] = Letters2Num[Letters2Num["[endurance]"]+1]
			_output("has reset their Guard to [combatstacks["Guard"]]!", "oocalert", "outputall.output")
		if("Break")
			combatstacks["Guard"] = 0
			_output("has had their Guard broken!", "oocalert", "outputall.output")
  /*******************************************/
 /*************** dodge **************/
/*******************************************///
/mob/verb/DodgeCalc()
	set category = "Calculator"
	var/guardvalue = input(src, "How much is your Agility?", "?") in Letters2Num
	if(guardvalue in Letters2Num)
		var/attackvalue = input(src, "How much is the Agility in question?", "?") in Letters2Num
		var/value = 4 - (abs((Letters2Num[guardvalue] - Letters2Num[attackvalue])))
		_output("You would have [value] dodges", "selfalert", "outputall.output")
/mob/verb/Dodge()
	set category = "Combat"
	DodgeStack(input(src, "What do you want to do with your dodging?" , "Dodge") in list("Add", "Subtract", "Reset"))
/mob/proc/DodgeStack(var/command)
	switch(command)
		if("Add")
			combatstacks["Dodge"]++
			_output("has dodged [combatstacks["Dodge"]] times!", "oocalert", "outputall.output")
		if("Subtract")
			combatstacks["Dodge"]--
			_output("has reduced their dodges to [combatstacks["Dodge"]]", "oocalert", "outputall.output")
		if("Reset")
			combatstacks["Dodge"] = 0
			_output("has reset their dodges!", "oocalert", "outputall.output")

  /*******************************************/
 /*************** constitution **************/
/*******************************************///
/mob/proc/getConst()
	var/lowest
	var/highest
	if(endurance < stamina-10)
		lowest = return_stat_grade(get_grade_stat(endurance))
		highest = return_stat_grade(get_grade_stat(stamina-10))
	else
		lowest = stamina
		highest = endurance
	return get_grade_stat((lowest+highest) / 2)
/mob/verb/TestConst()
	world<<return_stat_grade(get_grade_stat(endurance))
	world<<return_stat_grade(get_grade_stat(stamina-10))
	world<<getConst()
// E = 0, E+ = 1, D- = 2, D = 3, D+ = 4, C- = 5, C = 6

  /*******************************************/
 /*************** Health Tracker **************/
/*******************************************///
/mob/var/list/BodyTracker = list("Head" = "n", "Body" = "n" , "L.Arm" = "n", "R.Arm" = "n", "L.Leg" = "n", "R.Leg" = "n")
/mob/var/list/Injuries = list()
// n = none, m = min, L = light, M = mod, h = heavy, s = severe, c = critical, p = perm 
/mob/verb/Tracker()
	set category = "Combat Testing"
	TrackerTable()
/mob/proc/TranslateDamage(n)
	var/list/damage = list("None" = 0, "Miniscule" = 0, "Light" = 0, "Moderate" = 0, "Heavy"= 0 , "Severe" = 0,"Critical" = 0, "Perm" = 0)
	for(var/s in 1 to length(n))
		switch(n[s])
			if("n")
				damage["None"]++
			if("m")
				damage["Miniscule"]++
			if("L")
				damage["Light"]++
			if("M")
				damage["Moderate"]++
			if("h")
				damage["Heavy"]++
			if("s")
				damage["Severe"]++
			if("c")
				damage["Critical"]++
			if("p")
				damage["Perm"]++
	var/data = "[damage["None"] ? "None([damage["None"]])" : ""][damage["Miniscule"] ? "Miniscule([damage["Miniscule"]])" : ""][damage["Light"] ? "Light([damage["Light"]])" : ""][damage["Moderate"] ? "Moderate([damage["Moderate"]])" : ""][damage["Heavy"] ? "Heavy([damage["Heavy"]])" : ""][damage["Severe"] ? "Severe([damage["Severe"]])" : ""][damage["Critical"] ? "Critical([damage["Critical"]])" : ""]"
	world<<data
	return data
// n = none, m = min, L = light, M = mod, h = heavy, s = severe, c = critical, p = perm 
/mob/proc/ApplyInjury(limb)
	if(BodyTracker[limb] == "n")
		BodyTracker[limb] = ""
	switch(input(src, "What type of damage are you applying to [limb]?", "Damage") in list("Miniscule", "Light", "Moderate", "Heavy", "Severe", "Critical", "Perm"))
		if("Miniscule")
			BodyTracker[limb]+="m"
		if("Light")
			BodyTracker[limb]+="L"
		if("Moderate")
			BodyTracker[limb]+="M"
		if("Heavy")
			BodyTracker[limb]+="h"
		if("Severe")
			BodyTracker[limb]+="s"
		if("Critical")
			BodyTracker[limb]+="c"
		if("Perm")
			BodyTracker[limb]+="p"
	TrackerTable()
/mob/proc/ForceInjury(limb, dmg)
	if(BodyTracker[limb] == "n")
		BodyTracker[limb] = ""
	switch(dmg)
		if("Miniscule")
			BodyTracker[limb]+="m"
		if("Light")
			BodyTracker[limb]+="L"
		if("Moderate")
			BodyTracker[limb]+="M"
		if("Heavy")
			BodyTracker[limb]+="h"
		if("Severe")
			BodyTracker[limb]+="s"
		if("Critical")
			BodyTracker[limb]+="c"
		if("Perm")
			BodyTracker[limb]+="p"
	world<<"We get here"
//give injury, view injury, veerb that lets u open up their table and view
Injury
	var/desc
	var/timestamp
	var/giver
	var/giverkey
	var/limb
	var/dmg
	var/name
	New(mob/g )
		timestamp = time2text(world.realtime)
		giver = g.name
		giverkey = g.key
		..()
/mob/proc/GiveInjury(mob/p)
	var/limb = input(src, "What limb is this injury being applied to?") in list("Head", "Body", "L.Arm", "R.Arm","L.Leg","R.Leg")
	var/damage = input(src, "What limb is this injury being applied to?") in list("Miniscule", "Light", "Moderate", "Heavy", "Severe", "Critical", "Perm")
	var/Injury/nInj = new(src)
	nInj.name = input(src, "What is the name of the injury?") as text
	nInj.desc = input(src, "What is the desc of the injury?") as message
	nInj.limb = limb
	nInj.dmg = damage
	if((input(p, "[p.getStrangerNameNoHTML(src)] is trying to apply a [damage] damage injury to your [limb] with the name of [nInj.name] and desc of [nInj.desc ], do you accept?") in list("Yes", "No")) == "Yes")
		p.ForceInjury(limb,damage)
		p.Injuries += nInj
		p.NewInjury = TRUE
		for(var/Injury/x in p.Injuries)
			world<<x.name
			world<<x.limb
			world<<x.dmg
			world<<x.timestamp
	else
		del nInj
/mob/verb/testGiveinjury()
	set category  = "Combat Testing"
	GiveInjury(src)
/mob/proc/ParseInjuries()
	var/dat = ""
	for(var/Injury/x in Injuries)
		var/color
		switch(x.dmg)
			if("Miniscule")
				color="#ffffff"
			if("Light")
				color="#0000ff"
			if("Moderate")
				color="#ffff00"
			if("Heavy")
				color="#ffa500"
			if("Severe")
				color="#ff0000"
			if("Critical")
				color="#ff0000"
			if("Perm")
				color="#808080"
		dat += "<u><b><font color = [color]>[x.dmg]</font></b></u><br><b>Limb:</b>[x.limb]<br><b>Name:</b>[x.name]<br><b>Description:</b> [x.desc]<br><b>Time:</b>[x.timestamp]<br>"
	return dat
/mob/proc/TrackerTable()
	var/html = {"
	<html>
<head>
<style>
table, th, td {
  border: 1px solid black;
}
</style>
</head>
	<table>
        <tr>
            <th>Limb</th>
            <th>Current Injury</th>
        </tr>
    <tbody>
        <tr>
            <td>Head:</td>
            <td>[TranslateDamage(BodyTracker["Head"])]</td>
			<td><a href=?src=\ref[src];action=damage;limb=Head>Damage</a>
			<td><a href=?src=\ref[src];action=clear;limb=Head>Clear</a></td>
        </tr>
		 <tr>
            <td>Body:</td>
            <td>[TranslateDamage(BodyTracker["Body"])]</td>
			<td><a href=?src=\ref[src];action=damage;limb=Body>Damage</a>
			<td><a href=?src=\ref[src];action=clear;limb=Body>Clear</a></td>
        </tr>
		 <tr>
            <td>L. Arm:</td>
            <td>[TranslateDamage(BodyTracker["L.Arm"])]</td>
			<td><a href=?src=\ref[src];action=damage;limb=L.Arm>Damage</a>
			<td><a href=?src=\ref[src];action=clear;limb=L.Arm>Clear</a></td>
        </tr>
		 <tr>
            <td>R. Arm:</td>
            <td>[TranslateDamage(BodyTracker["R.Arm"])]</td>
			<td><a href=?src=\ref[src];action=damage;limb=R.Arm>Damage</a>
			<td><a href=?src=\ref[src];action=clear;limb=R.Arm>Clear</a></td>
        </tr>
		 <tr>
            <td>L. Leg:</td>
            <td>[TranslateDamage(BodyTracker["L.Leg"])]</td>
			<td><a href=?src=\ref[src];action=damage;limb=L.Leg>Damage</a>
			<td><a href=?src=\ref[src];action=clear;limb=L.Leg>Clear</a></td>
        </tr>
		 <tr>
            <td>R. Leg:</td>
            <td>[TranslateDamage(BodyTracker["R.Leg"])]</td>
			<td><a href=?src=\ref[src];action=damage;limb=R.Leg>Damage</a>
			<td><a href=?src=\ref[src];action=clear;limb=R.Leg>Clear</a></td>
        </tr>
    </tbody>
</table>
	"}
	usr << browse(html, "window=tracker;size=875x400")
