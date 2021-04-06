/mob/var/cert = 0

obj/RPFlag/verb/Set_Icon()
	set src in view()

	if(!(src in usr.rpFlags))
		usr << "You can't change the icon of flags that don't belong to you."
		return

	if(!usr.Donator && !usr.cert)
		usr << "This is only for subscribers! Subscribe here: https://secure.byond.com/games/AxiomStudios/Tiria/subscribe"
		return

	icon = input("Please select an icon") as icon