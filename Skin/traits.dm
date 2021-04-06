proc
	pickweight(var/list/L)
		var/total = 0
		var/item
		for(item in L)
			total += (L[item] || 1)
		total *= rand()
		for(item in L)
			total -= (L[item] || 1)
			if(total < 0) return item
// go to buying and adjust for hardworker, genius 
//give free skill perk for skilled ?
// adjust stats for able bodied, add extra decline
// let driven pick
//will, ful picks a will perk
/mob/var/list/points = list("spec" = 1, "skill" = 0, "will" = 0)
/mob/var/got_skill = 0
/obj/jutsu/var/skill_perk = 0 
mob/verb/TraitTest()
	var/list/traitlist1 = list("Talentless" = 0, "Fortunate I"= 0, "Fortunate II"= 0, "Fortunate III"= 0, "Willful"= 0, "Driven"= 0, "Able-Bodied"= 0, "Brilliant"= 0, "Skilled"= 0, "Genius"= 0, "Hard Worker"= 0, "Cursed" = 0)
	var/list/traitlist = list("Talentless" = 50, "Fortunate I" = 10, "Fortunate II" = 5, "Fortunate III" = 1, "Willful" = 10, "Driven" = 5, "Able-Bodied" = 10, "Brilliant" = 10, "Skilled" = 10, "Genius" = 5, "Hard Worker" = 5, "Cursed" = 1 )
	for(var/x in 1 to 100)
		var/y = pickweight(traitlist)
		world<<"[x] : [y]"
		traitlist1[y]++
	for(var/x in traitlist1)
		world<<"[x]:[traitlist1[x]]"

/mob/proc/ChangeTrait(var/redo)
	if(redo)
		Trait = input(src, "What one", "?") in list("Talentless", "Fortunate I", "Fortunate II", "Fortunate III", "Willful", "Able-Bodied", "Brilliant", "Skilled", "Genius", "Hard Worker", "Cursed")
	else
		Trait = input(src, "What one", "?") in list("Talentless", "Fortunate I", "Fortunate II", "Fortunate III", "Willful", "Driven", "Able-Bodied", "Brilliant", "Skilled", "Genius", "Hard Worker", "Cursed")
	trait_text = null
	switch(Trait)
		if("Skilled")
			points["skill"] = 2
		if("Able-Bodied")
			var/list/thelist = list("strength", "speed" , "agility", "endurance", "stamina")
			var/x = input(src, "What stat do you want to have an extra cap in?", "?") in thelist
			thelist -= x
			able_bodied += x
			able_bodied += input(src, "What stat do you want to have an extra cap in?", "?") in thelist
		if("Driven")
			if(!redo)
				ChangeTrait(TRUE)
		if("Willful")
			points["will"] = 1
		if("Fortunate I")
			give_ryo(5000)
		if("Fortunate II")
			give_ryo(1000)
		if("Fortunate III")
			give_ryo(15000)
	character_box.update_info(src)
mob/proc/traits() // redo this
	src.Trait = "Talentless"
	var/list/traitlist = list("Talentless" = 50, "Fortunate I" = 10, "Fortunate II" = 5, "Fortunate III" = 1, "Willful" = 10, "Driven" = 5, "Able-Bodied" = 10, "Brilliant" = 10, "Skilled" = 10, "Genius" = 5, "Hard Worker" = 5, "Cursed" = 1 )
	Trait = pickweight(traitlist)
	switch(Trait)
		if("Skilled")
			points["skill"] = 2
		if("Able-Bodied")
			var/list/thelist = list("strength", "speed" , "agility", "endurance", "stamina")
			var/x = input(src, "What stat do you want to have an extra cap in?", "?") in thelist
			thelist -= x
			able_bodied += x
			able_bodied += input(src, "What stat do you want to have an extra cap in?", "?") in thelist
		if("Driven")
			ChangeTrait(TRUE)
		if("Willful")
			points["will"] = 1
		if("Fortunate I")
			PayBoost+=150
			give_ryo(5000)
		if("Fortunate II")
			PayBoost+=300
			give_ryo(1000)
		if("Fortunate III")
			PayBoost+=450
			give_ryo(15000)