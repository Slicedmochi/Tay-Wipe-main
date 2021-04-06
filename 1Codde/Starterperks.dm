/mob/proc/give_starter_perk()
	stat_points += 20
	var/to_give = "[Clan] Clan"
	givePerk(to_give)
	if(progress_box)
		progress_box.display_interface(progress_list, src)
		progress_box.update_bars(src)
	if(character_box)
		character_box.update_bars(src)
	if(jutsu_box)
		jutsu_box.display_interface(contents)
	switch(Clan)
		if("Hyuuga")
			src.overlays += 'Hyuuga.dmi'
			givePerk("Byakugan")
		if("Kaguya")
			src.overlays += 'Kaguya.dmi'
		if("Inuzuka")
			new/obj/items/InuzukaEyeMarkings(src)
