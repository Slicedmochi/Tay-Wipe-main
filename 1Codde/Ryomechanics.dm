/********************************************/
/******** Coded by jOrDaN 09 DEC 2020 ********/
/********************************************/
/mob/proc/HasRyo()
	var/obj/items/Ryo/R = locate() in src
	if(!R)
		return FALSE
	return R
/mob/proc/GiveRyo(n)
	var/obj/items/Ryo/R = HasRyo()
	if(!R)
		R = new(src)
		R.amount = n
		R.Update()
	else
		R.amount += n
		R.Update()
/mob/proc/BuySomething(n, obj/items/purchase, bulk)
	var/obj/items/Ryo/R = HasRyo()
	if(R.amount >= n)
		R.amount -= n
		R.Update()
		contents += purchase
		if(!bulk)
			src<<output("You spend [n] Ryo to buy a [purchase.name].","outputic.output")
			src<<output("You spend [n] Ryo to buy a [purchase.name].","outputall.output")
	else
		if(!bulk)
			src<<output("[purchase.name] costs [n] Ryo, you only have [R.amount] Ryo.","outputic.output")
			src<<output("[purchase.name] costs [n] Ryo, you only have [R.amount] Ryo..","outputall.output")
/mob/proc/SellSomething(n, obj/items/sell)
	GiveRyo(n)
	src<<output("<font size = -3>The shopkeeper hands you [n] Ryo for [sell.name].","outputic.output")
	src<<output("<font size = -3>The shopkeeper hands you [n] Ryo for [sell.name].","outputall.output")
/mob/proc/RestackRyo()
	var/obj/items/Ryo/R = HasRyo()
	for(var/obj/items/Ryo/X in contents)
		if(X == R)
			continue
		R.amount += X.amount
		del X
	R.Update()
/mob/proc/RestackSenbon()
	var/obj/items/Weapon/Senbon/S = locate() in src
	for(var/obj/items/Weapon/Senbon/X in contents)
		if(X == S)
			continue
		S.senbon += X.senbon
		del X
	suffix = "You current have [S.senbon] in this stack"
//Debug
/mob/verb/Restack()
	RestackRyo()
