//New datum
Equipment
	var/ownerkey
//New vars
/Equipment/var/carrying_capacity = 5
/Equipment/var/carrying_boost = 0
/Equipment/var/current_carrying = 0
/Equipment/var/list/inventory = list()
/Equipment/var/tmp/open = 0
/mob/var/Equipment/Bag = new
//New procs
//Have to make sure it is the right items going in or out, of course (later)
/Equipment/proc/TotalCarrying()
	return carrying_capacity + carrying_boost
/mob/proc/TransferWeapon(obj/items/weapon)
	//transfer a weapon to the equipment
	if((weapon.Weight + Bag.current_carrying) > Bag.TotalCarrying())
		_output("There isn't enough space in your bag to do this!", "selfalert", "outputall.output")
	else
		Bag.current_carrying += weapon.Weight
		src.contents -= weapon
		Bag.inventory.Add(weapon)
		_output("[weapon.name]","weapontransfer", "outputall.output")
		_output("[weapon.name]","weapontransfer", "outputic.output")
		winset(src, "Bag.capacity", "text=\"Current([Bag.current_carrying]/[Bag.TotalCarrying()])\"")
/mob/proc/ReturnWeapon(obj/items/weapon)
	Bag.current_carrying -= weapon.Weight
	if(Bag.current_carrying < 1) Bag.current_carrying = 0
	Bag.inventory.Remove(weapon)
	weapon.Move(src)
	_output("[weapon.name]","weaponreturn", "outputall.output")
	_output("[weapon.name]","weaponreturn", "outputic.output")
/Equipment/proc/DisplayUpdate()
	if(!open) return
	var/const/GridID = "Bag.inv"
	winset(usr, GridID, "cells=0x0")
	for(var/y in 1 to inventory.len) // 1
		usr<<output(inventory[y], "[GridID]:[1],[y]")
	winset(usr, GridID, "cells=1x[inventory.len]")
/obj/items/Weapon
	MouseDrop(over_object, src_location, over_location, src_control, over_control, params)
		. = ..()
		switch(over_control)
			if("Bag.inv")
				usr.TransferWeapon(src)
				usr.Bag.DisplayUpdate()
			if("tabpane.info1")
				usr.ReturnWeapon(src)
				usr.Bag.DisplayUpdate()
/obj/items/Scrolls/Scroll/var/SealMaterial = ""
/obj/items/Scrolls/Scroll/var/SealDate = null
/obj/items/Scrolls/Scroll/var/mob/bodyholder
/obj/items/Scrolls/Scroll
	MouseDrop(over_object, src_location, over_location, src_control, over_control, params)
		. = ..()
		switch(over_control)
			if("Bag.inv")
				usr.TransferWeapon(src)
				usr.Bag.DisplayUpdate()
			if("tabpane.info1")
				usr.ReturnWeapon(src)
				usr.Bag.DisplayUpdate()
/obj/items/Scrolls/Scroll/verb/Unseal()
	if(bodyholder)
		usr._output(bodyholder.name, "unseal", "outputall.output")
		usr._output(bodyholder.name, "unseal", "outputic.output")
		bodyholder.loc = usr.loc
		bodyholder = null
	else if(SealDate)
		switch(Weight)
			if(2.5)
				usr._output("3x3 [SealMaterial]", "unseal", "outputall.output")
				usr._output("3x3 [SealMaterial]", "unseal", "outputic.output")
			if(5)
				usr._output("5x5 [SealMaterial]", "unseal", "outputall.output")
				usr._output("5x5 [SealMaterial]", "unseal", "outputic.output")
			if(7.5)
				usr._output("7x7 [SealMaterial]", "unseal", "outputall.output")
				usr._output("7x7 [SealMaterial]", "unseal", "outputic.output")
			if(10)
				usr._output("9x9 [SealMaterial]", "unseal", "outputall.output")
				usr._output("9x9 [SealMaterial]", "unseal", "outputic.output")
	else
		usr._output("There's nothing to unseal", "selfalert", "outputall.output")
/obj/items/Scrolls/Scroll/verb/Seal_Material()
	SealDate = time2text(world.realtime)
	var/size = input(usr, "What size are you sealing?" , "Seal size") in list("3x3","5x5","7x7","9x9")
	switch(size)
		if("3x3")
			Weight = 2.5
		if("5x5")
			Weight = 5
		if("7x7")
			Weight = 7.5
		if("9x9")
			Weight = 10
	SealMaterial = input(usr, "What did you seal inside? (Earth, Sand, Water, etc") as text
	if(length(SealMaterial) > 10)
		SealMaterial = null
		SealDate = null
		return
//debug
/mob/verb/OpenBag()
	set category = "Debug"
	if(Bag.open)
		winshow(src, "Bag", 0)
		Bag.open = 0 
	else
		winshow(src, "Bag", 1)
		Bag.open = 1
		Bag.DisplayUpdate()
/mob/verb/MakeTestScroll()
	set category = "Debug"
	new/obj/items/Scrolls/Scroll(src)
/mob/verb/RemoveBag()
	set category = "Debug"
	for(var/obj/x in Bag.inventory)
		Bag.inventory.Remove(x)
		x.loc = null
	Bag.current_carrying = 0
	Bag.inventory = list()
	winset(src, "Bag.capacity", "text=\"Current([Bag.current_carrying]/[Bag.TotalCarrying()])\"")