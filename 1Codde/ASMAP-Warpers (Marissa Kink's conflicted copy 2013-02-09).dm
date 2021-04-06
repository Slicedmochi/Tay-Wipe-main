obj
	proc
		Steppedon(mob/M)
		..()
		Steppedoff(mob/M)
		..()






turf
	Exited(M)
		if(istype(M,/mob))
			for(var/obj/A in src)
				var/obj/O = A
				for(O in src) if(istype(O)) O.Steppedoff(M)
		return ..()
	Entered(M)
		if(istype(M,/mob))
			var/obj/O
			for(O in src) if(istype(O)) O.Steppedon(M)
		return ..()
mob/Bump(atom/O)
	if(istype(O,/obj/building/DoorR))
		if(O:password)
			var/list/HasKey=list()
			for(var/obj/items/Key/K in usr.contents)
				HasKey+=K
			if(!HasKey.len)
				usr<<"Locked."
				return
			for(var/obj/items/Key/K in HasKey)
				if(K.Passcode==O:password)
					O:Open()
					return
			usr<<"Locked."
			return
		O:Open()
	if(istype(O,/obj/building/DoorL))
		if(O:password)
			var/list/HasKey=list()
			for(var/obj/items/Key/K in usr.contents)
				HasKey+=K
			if(!HasKey.len)
				usr<<"Locked."
				return
			for(var/obj/items/Key/K in HasKey)
				if(K.Passcode==O:password)
					O:Open()
					return
			usr<<"Locked."
			return
		O:Open()
	if(istype(O,/obj/building/CDoor))
		if(skinput2("This door requires a password.(Blank to close)","Password")==O:password)
			O:Open()
obj/items/Key
	icon='Key.dmi'
	var/Passcode=null
obj/building
	DoorR
		icon='door.dmi'
		icon_state="close1"
		density=1
		var/Opacity=0
		var/password=null
		New()
			..()
			if(Opacity)
				opacity=1
		proc/Open()
			layer=9
			flick("opening1",src)
			icon_state="open1"
			if(Opacity) opacity=0
			density=0
			spawn(30)
				flick("closing1",src)
				icon_state="close1"
				density=1
				layer=25
				if(Opacity) opacity=1
	DoorL
		icon='door.dmi'
		icon_state="close2"
		density=1
		var/Opacity=0
		var/password=null
		New()
			..()
			if(Opacity)
				opacity=1
		proc/Open()
			layer=9
			flick("opening2",src)
			icon_state="open2"
			if(Opacity) opacity=0
			density=0
			spawn(30)
				layer=25
				flick("closing2",src)
				icon_state="close2"
				density=1
				layer=25
				if(Opacity) opacity=1
	CDoor
		icon='prison.dmi'
		icon_state="doorc"
		var/password="Foop"
		density=1
		proc/Open()
			layer=9
			icon_state="dooropen"
			density=0
			spawn(30)
				layer=25
				icon_state="doorc"
				density=1
				layer=25
var/turn=0
mob/verb
	TurnN()
		set hidden=1
		speeding=0
		icon_state = ""
		dir=NORTH
	TurnS()
		set hidden=1
		speeding=0
		icon_state = ""
		dir=SOUTH
	TurnE()
		set hidden=1
		speeding=0
		icon_state = ""
		dir=EAST
	TurnW()
		set hidden=1
		speeding=0
		icon_state = ""
		dir=WEST
turf
	WARPER
		density=0
		var/
			xto=1
			yto=1
			zto=1
		Entered()
			usr.loc=locate(xto,yto,zto)
turf
	WARPERHOMESKIRI
		layer=999
		density=0
		var/goingto
		Entered()
			usr.layer=70
			usr.loc=locate(goingto)
		Exited()
			usr.layer=initial(usr.layer)

		tower
			in1
				goingto=/turf/WARPERHOMESKIRI/tower/out1
			out1
				goingto=/turf/WARPERHOMESKIRI/tower/in1

			in2
				goingto=/turf/WARPERHOMESKIRI/tower/out2
			out2
				goingto=/turf/WARPERHOMESKIRI/tower/in2

			in3
				goingto=/turf/WARPERHOMESKIRI/tower/out3
			out3
				goingto=/turf/WARPERHOMESKIRI/tower/in3






		Sect1A
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect1A/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect1A/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect1A/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect1A/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect1A/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect1A/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect1A/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect1A/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect1A/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect1A/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect1A/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect1A/E2
		Spa
			e1
				goingto=/turf/WARPERHOMESKIRI/Spa/e2
			e2
				goingto=/turf/WARPERHOMESKIRI/Spa/e1
			ea1
				goingto=/turf/WARPERHOMESKIRI/Spa/ea2
			ea2
				goingto=/turf/WARPERHOMESKIRI/Spa/ea1
		Sect1
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect1/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect1/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect1/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect1/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect1/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect1/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect1/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect1/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect1/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect1/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect1/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect1/E2
		Sect2
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect2/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect2/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect2/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect2/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect2/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect2/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect2/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect2/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect2/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect2/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect2/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect2/E2
		Sect3
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect3/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect3/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect3/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect3/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect3/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect3/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect3/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect3/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect3/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect3/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect3/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect3/E2
		Sect4
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect4/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect4/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect4/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect4/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect4/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect4/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect4/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect4/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect4/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect4/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect4/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect4/E2
		Sect5
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect5/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect5/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect5/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect5/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect5/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect5/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect5/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect5/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect5/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect5/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect5/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect5/E2
		Sect6
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect6/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect6/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect6/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect6/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect6/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect6/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect6/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect6/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect6/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect6/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect6/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect6/E2
		Sect7
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect7/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect7/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect7/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect7/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect7/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect7/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect7/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect7/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect7/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect7/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect7/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect7/E2
		Sect8
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect8/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect8/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect8/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect8/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect8/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect8/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect8/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect8/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect8/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect8/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect8/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect8/E2
		Sect9
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect9/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect9/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect9/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect9/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect9/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect9/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect9/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect9/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect9/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect9/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect9/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect9/E2
		Sect10
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect10/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect10/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect10/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect10/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect10/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect10/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect10/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect10/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect10/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect10/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect10/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect10/E2
		Sect11
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect11/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect11/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect11/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect11/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect11/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect11/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect11/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect11/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect11/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect11/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect11/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect11/E2
		Sect12
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect12/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect12/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect12/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect12/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect12/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect12/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect12/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect12/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect12/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect12/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect12/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect12/E2
		Sect13
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect13/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect13/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect13/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect13/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect13/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect13/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect13/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect13/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect13/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect13/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect13/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect13/E2
		Sect14
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect14/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect14/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect14/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect14/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect14/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect14/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect14/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect14/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect14/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect14/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect14/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect14/E2
		Sect15
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect15/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect15/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect15/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect15/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect15/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect15/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect15/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect15/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect15/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect15/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect15/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect15/E2
		Sect16
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect16/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect16/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect16/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect16/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect16/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect16/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect16/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect16/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect16/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect16/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect16/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect16/E2
		Sect17
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect17/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect17/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect17/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect17/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect17/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect17/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect17/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect17/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect17/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect17/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect17/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect17/E2
		Sect18
			A1
				goingto=/turf/WARPERHOMESKIRI/Sect18/B1
			A2
				goingto=/turf/WARPERHOMESKIRI/Sect18/B2
			B1
				goingto=/turf/WARPERHOMESKIRI/Sect18/A1
			B2
				goingto=/turf/WARPERHOMESKIRI/Sect18/A2



			C1
				goingto=/turf/WARPERHOMESKIRI/Sect18/D1
			C2
				goingto=/turf/WARPERHOMESKIRI/Sect18/D2
			D1
				goingto=/turf/WARPERHOMESKIRI/Sect18/C1
			D2
				goingto=/turf/WARPERHOMESKIRI/Sect18/C2

			E1
				goingto=/turf/WARPERHOMESKIRI/Sect18/F1
			E2
				goingto=/turf/WARPERHOMESKIRI/Sect18/F2
			F1
				goingto=/turf/WARPERHOMESKIRI/Sect18/E1
			F2
				goingto=/turf/WARPERHOMESKIRI/Sect18/E2




	WARPERHOMESSUNA
		layer=999
		density=0
		var/goingto
		Entered()
			usr.layer=70
			usr.loc=locate(goingto)
		Exited()
			usr.layer=initial(usr.layer)
		newwarpers
			in1
				goingto=/turf/WARPERHOMESSUNA/newwarpers/out1
			out1
				goingto=/turf/WARPERHOMESSUNA/newwarpers/in1

			in2
				goingto=/turf/WARPERHOMESSUNA/newwarpers/out2
			out2
				goingto=/turf/WARPERHOMESSUNA/newwarpers/in2

			in3
				goingto=/turf/WARPERHOMESSUNA/newwarpers/out3
			out3
				goingto=/turf/WARPERHOMESSUNA/newwarpers/in3

			in4
				goingto=/turf/WARPERHOMESSUNA/newwarpers/out4
			out4
				goingto=/turf/WARPERHOMESSUNA/newwarpers/in4

			in5
				goingto=/turf/WARPERHOMESSUNA/newwarpers/out5
			out5
				goingto=/turf/WARPERHOMESSUNA/newwarpers/in5

			in6
				goingto=/turf/WARPERHOMESSUNA/newwarpers/out6
			out6
				goingto=/turf/WARPERHOMESSUNA/newwarpers/in6

			in7
				goingto=/turf/WARPERHOMESSUNA/newwarpers/out7
			out7
				goingto=/turf/WARPERHOMESSUNA/newwarpers/in7

			in8
				goingto=/turf/WARPERHOMESSUNA/newwarpers/out8
			out8
				goingto=/turf/WARPERHOMESSUNA/newwarpers/in8

			in9
				goingto=/turf/WARPERHOMESSUNA/newwarpers/out9
			out9
				goingto=/turf/WARPERHOMESSUNA/newwarpers/in9

			in10
				goingto=/turf/WARPERHOMESSUNA/newwarpers/out10
			out10
				goingto=/turf/WARPERHOMESSUNA/newwarpers/in10

			in11
				goingto=/turf/WARPERHOMESSUNA/newwarpers/out11
			out11
				goingto=/turf/WARPERHOMESSUNA/newwarpers/in11







		Sect1A
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect1A/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect1A/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect1A/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect1A/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect1A/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect1A/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect1A/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect1A/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect1A/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect1A/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect1A/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect1A/E2
		Sect1
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect1/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect1/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect1/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect1/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect1/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect1/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect1/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect1/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect1/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect1/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect1/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect1/E2
		Sect2
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect2/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect2/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect2/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect2/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect2/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect2/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect2/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect2/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect2/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect2/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect2/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect2/E2
		Sect3
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect3/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect3/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect3/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect3/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect3/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect3/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect3/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect3/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect3/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect3/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect3/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect3/E2
		Sect4
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect4/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect4/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect4/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect4/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect4/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect4/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect4/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect4/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect4/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect4/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect4/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect4/E2
		Sect5
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect5/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect5/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect5/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect5/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect5/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect5/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect5/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect5/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect5/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect5/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect5/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect5/E2
		Sect6
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect6/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect6/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect6/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect6/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect6/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect6/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect6/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect6/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect6/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect6/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect6/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect6/E2
		Sect7
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect7/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect7/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect7/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect7/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect7/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect7/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect7/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect7/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect7/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect7/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect7/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect7/E2
		Sect8
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect8/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect8/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect8/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect8/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect8/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect8/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect8/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect8/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect8/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect8/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect8/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect8/E2
		Sect9
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect9/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect9/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect9/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect9/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect9/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect9/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect9/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect9/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect9/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect9/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect9/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect9/E2
		Sect10
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect10/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect10/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect10/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect10/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect10/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect10/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect10/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect10/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect10/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect10/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect10/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect10/E2
		Sect11
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect11/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect11/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect11/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect11/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect11/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect11/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect11/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect11/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect11/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect11/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect11/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect11/E2
		Sect12
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect12/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect12/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect12/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect12/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect12/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect12/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect12/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect12/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect12/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect12/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect12/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect12/E2
		Sect13
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect13/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect13/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect13/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect13/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect13/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect13/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect13/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect13/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect13/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect13/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect13/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect13/E2
		Sect14
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect14/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect14/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect14/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect14/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect14/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect14/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect14/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect14/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect14/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect14/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect14/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect14/E2
		Sect15
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect15/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect15/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect15/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect15/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect15/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect15/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect15/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect15/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect15/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect15/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect15/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect15/E2
		Sect16
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect16/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect16/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect16/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect16/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect16/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect16/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect16/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect16/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect16/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect16/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect16/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect16/E2
		Sect17
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect17/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect17/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect17/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect17/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect17/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect17/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect17/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect17/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect17/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect17/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect17/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect17/E2
		Sect18
			A1
				goingto=/turf/WARPERHOMESSUNA/Sect18/B1
			A2
				goingto=/turf/WARPERHOMESSUNA/Sect18/B2
			B1
				goingto=/turf/WARPERHOMESSUNA/Sect18/A1
			B2
				goingto=/turf/WARPERHOMESSUNA/Sect18/A2



			C1
				goingto=/turf/WARPERHOMESSUNA/Sect18/D1
			C2
				goingto=/turf/WARPERHOMESSUNA/Sect18/D2
			D1
				goingto=/turf/WARPERHOMESSUNA/Sect18/C1
			D2
				goingto=/turf/WARPERHOMESSUNA/Sect18/C2

			E1
				goingto=/turf/WARPERHOMESSUNA/Sect18/F1
			E2
				goingto=/turf/WARPERHOMESSUNA/Sect18/F2
			F1
				goingto=/turf/WARPERHOMESSUNA/Sect18/E1
			F2
				goingto=/turf/WARPERHOMESSUNA/Sect18/E2
	WARPERCOUNTRY
		layer=999
		density=0
		var/goingto
		Entered()
			usr.loc=locate(goingto)
			..()
		Acave
			in1
				goingto=/turf/WARPERCOUNTRY/Acave/out1
			out1
				goingto=/turf/WARPERCOUNTRY/Acave/in1

			in2
				goingto=/turf/WARPERCOUNTRY/Acave/out2
			out2
				goingto=/turf/WARPERCOUNTRY/Acave/in2

			in3
				goingto=/turf/WARPERCOUNTRY/Acave/out3
			out3
				goingto=/turf/WARPERCOUNTRY/Acave/in3

			in4
				goingto=/turf/WARPERCOUNTRY/Acave/out4
			out4
				goingto=/turf/WARPERCOUNTRY/Acave/in4



		A
			in1
				goingto=/turf/WARPERCOUNTRY/A/out1
			out1
				goingto=/turf/WARPERCOUNTRY/A/in1

			in2
				goingto=/turf/WARPERCOUNTRY/A/out2
			out2
				goingto=/turf/WARPERCOUNTRY/A/in2

			in3
				goingto=/turf/WARPERCOUNTRY/A/out3
			out3
				goingto=/turf/WARPERCOUNTRY/A/in3

			in4
				goingto=/turf/WARPERCOUNTRY/A/out4
			out4
				goingto=/turf/WARPERCOUNTRY/A/in4

			in5
				goingto=/turf/WARPERCOUNTRY/A/out5
			out5
				goingto=/turf/WARPERCOUNTRY/A/in5

			in6
				goingto=/turf/WARPERCOUNTRY/A/out6
			out6
				goingto=/turf/WARPERCOUNTRY/A/in6

			in7
				goingto=/turf/WARPERCOUNTRY/A/out7
			out7
				goingto=/turf/WARPERCOUNTRY/A/in7

			in8
				goingto=/turf/WARPERCOUNTRY/A/out8
			out8
				goingto=/turf/WARPERCOUNTRY/A/in8

			in9
				goingto=/turf/WARPERCOUNTRY/A/out9
			out9
				goingto=/turf/WARPERCOUNTRY/A/in9

			in10
				goingto=/turf/WARPERCOUNTRY/A/out10
			out10
				goingto=/turf/WARPERCOUNTRY/A/in10

			in11
				goingto=/turf/WARPERCOUNTRY/A/out11
			out11
				goingto=/turf/WARPERCOUNTRY/A/in11

			in12
				goingto=/turf/WARPERCOUNTRY/A/out12
			out12
				goingto=/turf/WARPERCOUNTRY/A/in12

			in13
				goingto=/turf/WARPERCOUNTRY/A/out13
			out13
				goingto=/turf/WARPERCOUNTRY/A/in13

			in14
				goingto=/turf/WARPERCOUNTRY/A/out14
			out14
				goingto=/turf/WARPERCOUNTRY/A/in14


		B
			in1
				goingto=/turf/WARPERCOUNTRY/B/out1
			out1
				goingto=/turf/WARPERCOUNTRY/B/in1

			in2
				goingto=/turf/WARPERCOUNTRY/B/out2
			out2
				goingto=/turf/WARPERCOUNTRY/B/in2

			in3
				goingto=/turf/WARPERCOUNTRY/B/out3
			out3
				goingto=/turf/WARPERCOUNTRY/B/in3

			in4
				goingto=/turf/WARPERCOUNTRY/B/out4
			out4
				goingto=/turf/WARPERCOUNTRY/B/in4

			in5
				goingto=/turf/WARPERCOUNTRY/B/out5
			out5
				goingto=/turf/WARPERCOUNTRY/B/in5

			in6
				goingto=/turf/WARPERCOUNTRY/B/out6
			out6
				goingto=/turf/WARPERCOUNTRY/B/in6




	WARPERCHUUNINFOD
		layer=999
		density=0
		var/goingto
		Entered()
			usr.loc=locate(goingto)
			..()
		Sect1A
			A1
				goingto=/turf/WARPERCHUUNINFOD/Sect1A/A2
			A2
				goingto=/turf/WARPERCHUUNINFOD/Sect1A/A1
			B1
				goingto=/turf/WARPERCHUUNINFOD/Sect1A/B2
			B2
				goingto=/turf/WARPERCHUUNINFOD/Sect1A/B1



			C1
				goingto=/turf/WARPERCHUUNINFOD/Sect1A/C2
			C2
				goingto=/turf/WARPERCHUUNINFOD/Sect1A/C1

			D1
				goingto=/turf/WARPERCHUUNINFOD/Sect1A/D2
			D2
				goingto=/turf/WARPERCHUUNINFOD/Sect1A/D1

	WARPERHOMES
		layer=999
		density=0
		var/goingto
		Entered()
			usr.loc=locate(goingto)
			..()
		Sect1A
			A1
				goingto=/turf/WARPERHOMES/Sect1A/B1
			A2
				goingto=/turf/WARPERHOMES/Sect1A/B2
			B1
				goingto=/turf/WARPERHOMES/Sect1A/A1
			B2
				goingto=/turf/WARPERHOMES/Sect1A/A2



			C1
				goingto=/turf/WARPERHOMES/Sect1A/D1
			C2
				goingto=/turf/WARPERHOMES/Sect1A/D2
			D1
				goingto=/turf/WARPERHOMES/Sect1A/C1
			D2
				goingto=/turf/WARPERHOMES/Sect1A/C2

			E1
				goingto=/turf/WARPERHOMES/Sect1A/F1
			E2
				goingto=/turf/WARPERHOMES/Sect1A/F2
			F1
				goingto=/turf/WARPERHOMES/Sect1A/E1
			F2
				goingto=/turf/WARPERHOMES/Sect1A/E2
		Sect1
			A1
				goingto=/turf/WARPERHOMES/Sect1/B1
			A2
				goingto=/turf/WARPERHOMES/Sect1/B2
			B1
				goingto=/turf/WARPERHOMES/Sect1/A1
			B2
				goingto=/turf/WARPERHOMES/Sect1/A2



			C1
				goingto=/turf/WARPERHOMES/Sect1/D1
			C2
				goingto=/turf/WARPERHOMES/Sect1/D2
			D1
				goingto=/turf/WARPERHOMES/Sect1/C1
			D2
				goingto=/turf/WARPERHOMES/Sect1/C2

			E1
				goingto=/turf/WARPERHOMES/Sect1/F1
			E2
				goingto=/turf/WARPERHOMES/Sect1/F2
			F1
				goingto=/turf/WARPERHOMES/Sect1/E1
			F2
				goingto=/turf/WARPERHOMES/Sect1/E2
		Sect2
			A1
				goingto=/turf/WARPERHOMES/Sect2/B1
			A2
				goingto=/turf/WARPERHOMES/Sect2/B2
			B1
				goingto=/turf/WARPERHOMES/Sect2/A1
			B2
				goingto=/turf/WARPERHOMES/Sect2/A2



			C1
				goingto=/turf/WARPERHOMES/Sect2/D1
			C2
				goingto=/turf/WARPERHOMES/Sect2/D2
			D1
				goingto=/turf/WARPERHOMES/Sect2/C1
			D2
				goingto=/turf/WARPERHOMES/Sect2/C2

			E1
				goingto=/turf/WARPERHOMES/Sect2/F1
			E2
				goingto=/turf/WARPERHOMES/Sect2/F2
			F1
				goingto=/turf/WARPERHOMES/Sect2/E1
			F2
				goingto=/turf/WARPERHOMES/Sect2/E2
		Sect3
			A1
				goingto=/turf/WARPERHOMES/Sect3/B1
			A2
				goingto=/turf/WARPERHOMES/Sect3/B2
			B1
				goingto=/turf/WARPERHOMES/Sect3/A1
			B2
				goingto=/turf/WARPERHOMES/Sect3/A2



			C1
				goingto=/turf/WARPERHOMES/Sect3/D1
			C2
				goingto=/turf/WARPERHOMES/Sect3/D2
			D1
				goingto=/turf/WARPERHOMES/Sect3/C1
			D2
				goingto=/turf/WARPERHOMES/Sect3/C2

			E1
				goingto=/turf/WARPERHOMES/Sect3/F1
			E2
				goingto=/turf/WARPERHOMES/Sect3/F2
			F1
				goingto=/turf/WARPERHOMES/Sect3/E1
			F2
				goingto=/turf/WARPERHOMES/Sect3/E2
		Sect4
			A1
				goingto=/turf/WARPERHOMES/Sect4/B1
			A2
				goingto=/turf/WARPERHOMES/Sect4/B2
			B1
				goingto=/turf/WARPERHOMES/Sect4/A1
			B2
				goingto=/turf/WARPERHOMES/Sect4/A2



			C1
				goingto=/turf/WARPERHOMES/Sect4/D1
			C2
				goingto=/turf/WARPERHOMES/Sect4/D2
			D1
				goingto=/turf/WARPERHOMES/Sect4/C1
			D2
				goingto=/turf/WARPERHOMES/Sect4/C2

			E1
				goingto=/turf/WARPERHOMES/Sect4/F1
			E2
				goingto=/turf/WARPERHOMES/Sect4/F2
			F1
				goingto=/turf/WARPERHOMES/Sect4/E1
			F2
				goingto=/turf/WARPERHOMES/Sect4/E2
		Sect5
			A1
				goingto=/turf/WARPERHOMES/Sect5/B1
			A2
				goingto=/turf/WARPERHOMES/Sect5/B2
			B1
				goingto=/turf/WARPERHOMES/Sect5/A1
			B2
				goingto=/turf/WARPERHOMES/Sect5/A2



			C1
				goingto=/turf/WARPERHOMES/Sect5/D1
			C2
				goingto=/turf/WARPERHOMES/Sect5/D2
			D1
				goingto=/turf/WARPERHOMES/Sect5/C1
			D2
				goingto=/turf/WARPERHOMES/Sect5/C2

			E1
				goingto=/turf/WARPERHOMES/Sect5/F1
			E2
				goingto=/turf/WARPERHOMES/Sect5/F2
			F1
				goingto=/turf/WARPERHOMES/Sect5/E1
			F2
				goingto=/turf/WARPERHOMES/Sect5/E2
		Sect6
			A1
				goingto=/turf/WARPERHOMES/Sect6/B1
			A2
				goingto=/turf/WARPERHOMES/Sect6/B2
			B1
				goingto=/turf/WARPERHOMES/Sect6/A1
			B2
				goingto=/turf/WARPERHOMES/Sect6/A2



			C1
				goingto=/turf/WARPERHOMES/Sect6/D1
			C2
				goingto=/turf/WARPERHOMES/Sect6/D2
			D1
				goingto=/turf/WARPERHOMES/Sect6/C1
			D2
				goingto=/turf/WARPERHOMES/Sect6/C2

			E1
				goingto=/turf/WARPERHOMES/Sect6/F1
			E2
				goingto=/turf/WARPERHOMES/Sect6/F2
			F1
				goingto=/turf/WARPERHOMES/Sect6/E1
			F2
				goingto=/turf/WARPERHOMES/Sect6/E2
		Sect7
			A1
				goingto=/turf/WARPERHOMES/Sect7/B1
			A2
				goingto=/turf/WARPERHOMES/Sect7/B2
			B1
				goingto=/turf/WARPERHOMES/Sect7/A1
			B2
				goingto=/turf/WARPERHOMES/Sect7/A2



			C1
				goingto=/turf/WARPERHOMES/Sect7/D1
			C2
				goingto=/turf/WARPERHOMES/Sect7/D2
			D1
				goingto=/turf/WARPERHOMES/Sect7/C1
			D2
				goingto=/turf/WARPERHOMES/Sect7/C2

			E1
				goingto=/turf/WARPERHOMES/Sect7/F1
			E2
				goingto=/turf/WARPERHOMES/Sect7/F2
			F1
				goingto=/turf/WARPERHOMES/Sect7/E1
			F2
				goingto=/turf/WARPERHOMES/Sect7/E2
		Sect8
			A1
				goingto=/turf/WARPERHOMES/Sect8/B1
			A2
				goingto=/turf/WARPERHOMES/Sect8/B2
			B1
				goingto=/turf/WARPERHOMES/Sect8/A1
			B2
				goingto=/turf/WARPERHOMES/Sect8/A2



			C1
				goingto=/turf/WARPERHOMES/Sect8/D1
			C2
				goingto=/turf/WARPERHOMES/Sect8/D2
			D1
				goingto=/turf/WARPERHOMES/Sect8/C1
			D2
				goingto=/turf/WARPERHOMES/Sect8/C2

			E1
				goingto=/turf/WARPERHOMES/Sect8/F1
			E2
				goingto=/turf/WARPERHOMES/Sect8/F2
			F1
				goingto=/turf/WARPERHOMES/Sect8/E1
			F2
				goingto=/turf/WARPERHOMES/Sect8/E2
		Sect9
			A1
				goingto=/turf/WARPERHOMES/Sect9/B1
			A2
				goingto=/turf/WARPERHOMES/Sect9/B2
			B1
				goingto=/turf/WARPERHOMES/Sect9/A1
			B2
				goingto=/turf/WARPERHOMES/Sect9/A2



			C1
				goingto=/turf/WARPERHOMES/Sect9/D1
			C2
				goingto=/turf/WARPERHOMES/Sect9/D2
			D1
				goingto=/turf/WARPERHOMES/Sect9/C1
			D2
				goingto=/turf/WARPERHOMES/Sect9/C2

			E1
				goingto=/turf/WARPERHOMES/Sect9/F1
			E2
				goingto=/turf/WARPERHOMES/Sect9/F2
			F1
				goingto=/turf/WARPERHOMES/Sect9/E1
			F2
				goingto=/turf/WARPERHOMES/Sect9/E2
		Sect10
			A1
				goingto=/turf/WARPERHOMES/Sect10/B1
			A2
				goingto=/turf/WARPERHOMES/Sect10/B2
			B1
				goingto=/turf/WARPERHOMES/Sect10/A1
			B2
				goingto=/turf/WARPERHOMES/Sect10/A2



			C1
				goingto=/turf/WARPERHOMES/Sect10/D1
			C2
				goingto=/turf/WARPERHOMES/Sect10/D2
			D1
				goingto=/turf/WARPERHOMES/Sect10/C1
			D2
				goingto=/turf/WARPERHOMES/Sect10/C2

			E1
				goingto=/turf/WARPERHOMES/Sect10/F1
			E2
				goingto=/turf/WARPERHOMES/Sect10/F2
			F1
				goingto=/turf/WARPERHOMES/Sect10/E1
			F2
				goingto=/turf/WARPERHOMES/Sect10/E2
		Sect11
			A1
				goingto=/turf/WARPERHOMES/Sect11/B1
			A2
				goingto=/turf/WARPERHOMES/Sect11/B2
			B1
				goingto=/turf/WARPERHOMES/Sect11/A1
			B2
				goingto=/turf/WARPERHOMES/Sect11/A2



			C1
				goingto=/turf/WARPERHOMES/Sect11/D1
			C2
				goingto=/turf/WARPERHOMES/Sect11/D2
			D1
				goingto=/turf/WARPERHOMES/Sect11/C1
			D2
				goingto=/turf/WARPERHOMES/Sect11/C2

			E1
				goingto=/turf/WARPERHOMES/Sect11/F1
			E2
				goingto=/turf/WARPERHOMES/Sect11/F2
			F1
				goingto=/turf/WARPERHOMES/Sect11/E1
			F2
				goingto=/turf/WARPERHOMES/Sect11/E2
		Sect12
			A1
				goingto=/turf/WARPERHOMES/Sect12/B1
			A2
				goingto=/turf/WARPERHOMES/Sect12/B2
			B1
				goingto=/turf/WARPERHOMES/Sect12/A1
			B2
				goingto=/turf/WARPERHOMES/Sect12/A2



			C1
				goingto=/turf/WARPERHOMES/Sect12/D1
			C2
				goingto=/turf/WARPERHOMES/Sect12/D2
			D1
				goingto=/turf/WARPERHOMES/Sect12/C1
			D2
				goingto=/turf/WARPERHOMES/Sect12/C2

			E1
				goingto=/turf/WARPERHOMES/Sect12/F1
			E2
				goingto=/turf/WARPERHOMES/Sect12/F2
			F1
				goingto=/turf/WARPERHOMES/Sect12/E1
			F2
				goingto=/turf/WARPERHOMES/Sect12/E2
		Sect13
			A1
				goingto=/turf/WARPERHOMES/Sect13/B1
			A2
				goingto=/turf/WARPERHOMES/Sect13/B2
			B1
				goingto=/turf/WARPERHOMES/Sect13/A1
			B2
				goingto=/turf/WARPERHOMES/Sect13/A2



			C1
				goingto=/turf/WARPERHOMES/Sect13/D1
			C2
				goingto=/turf/WARPERHOMES/Sect13/D2
			D1
				goingto=/turf/WARPERHOMES/Sect13/C1
			D2
				goingto=/turf/WARPERHOMES/Sect13/C2

			E1
				goingto=/turf/WARPERHOMES/Sect13/F1
			E2
				goingto=/turf/WARPERHOMES/Sect13/F2
			F1
				goingto=/turf/WARPERHOMES/Sect13/E1
			F2
				goingto=/turf/WARPERHOMES/Sect13/E2
		Sect14
			A1
				goingto=/turf/WARPERHOMES/Sect14/B1
			A2
				goingto=/turf/WARPERHOMES/Sect14/B2
			B1
				goingto=/turf/WARPERHOMES/Sect14/A1
			B2
				goingto=/turf/WARPERHOMES/Sect14/A2



			C1
				goingto=/turf/WARPERHOMES/Sect14/D1
			C2
				goingto=/turf/WARPERHOMES/Sect14/D2
			D1
				goingto=/turf/WARPERHOMES/Sect14/C1
			D2
				goingto=/turf/WARPERHOMES/Sect14/C2

			E1
				goingto=/turf/WARPERHOMES/Sect14/F1
			E2
				goingto=/turf/WARPERHOMES/Sect14/F2
			F1
				goingto=/turf/WARPERHOMES/Sect14/E1
			F2
				goingto=/turf/WARPERHOMES/Sect14/E2
		Sect15
			A1
				goingto=/turf/WARPERHOMES/Sect15/B1
			A2
				goingto=/turf/WARPERHOMES/Sect15/B2
			B1
				goingto=/turf/WARPERHOMES/Sect15/A1
			B2
				goingto=/turf/WARPERHOMES/Sect15/A2



			C1
				goingto=/turf/WARPERHOMES/Sect15/D1
			C2
				goingto=/turf/WARPERHOMES/Sect15/D2
			D1
				goingto=/turf/WARPERHOMES/Sect15/C1
			D2
				goingto=/turf/WARPERHOMES/Sect15/C2

			E1
				goingto=/turf/WARPERHOMES/Sect15/F1
			E2
				goingto=/turf/WARPERHOMES/Sect15/F2
			F1
				goingto=/turf/WARPERHOMES/Sect15/E1
			F2
				goingto=/turf/WARPERHOMES/Sect15/E2
		Sect16
			A1
				goingto=/turf/WARPERHOMES/Sect16/B1
			A2
				goingto=/turf/WARPERHOMES/Sect16/B2
			B1
				goingto=/turf/WARPERHOMES/Sect16/A1
			B2
				goingto=/turf/WARPERHOMES/Sect16/A2



			C1
				goingto=/turf/WARPERHOMES/Sect16/D1
			C2
				goingto=/turf/WARPERHOMES/Sect16/D2
			D1
				goingto=/turf/WARPERHOMES/Sect16/C1
			D2
				goingto=/turf/WARPERHOMES/Sect16/C2

			E1
				goingto=/turf/WARPERHOMES/Sect16/F1
			E2
				goingto=/turf/WARPERHOMES/Sect16/F2
			F1
				goingto=/turf/WARPERHOMES/Sect16/E1
			F2
				goingto=/turf/WARPERHOMES/Sect16/E2
		Sect17
			A1
				goingto=/turf/WARPERHOMES/Sect17/B1
			A2
				goingto=/turf/WARPERHOMES/Sect17/B2
			B1
				goingto=/turf/WARPERHOMES/Sect17/A1
			B2
				goingto=/turf/WARPERHOMES/Sect17/A2



			C1
				goingto=/turf/WARPERHOMES/Sect17/D1
			C2
				goingto=/turf/WARPERHOMES/Sect17/D2
			D1
				goingto=/turf/WARPERHOMES/Sect17/C1
			D2
				goingto=/turf/WARPERHOMES/Sect17/C2

			E1
				goingto=/turf/WARPERHOMES/Sect17/F1
			E2
				goingto=/turf/WARPERHOMES/Sect17/F2
			F1
				goingto=/turf/WARPERHOMES/Sect17/E1
			F2
				goingto=/turf/WARPERHOMES/Sect17/E2
		Sect18
			A1
				goingto=/turf/WARPERHOMES/Sect18/B1
			A2
				goingto=/turf/WARPERHOMES/Sect18/B2
			B1
				goingto=/turf/WARPERHOMES/Sect18/A1
			B2
				goingto=/turf/WARPERHOMES/Sect18/A2



			C1
				goingto=/turf/WARPERHOMES/Sect18/D1
			C2
				goingto=/turf/WARPERHOMES/Sect18/D2
			D1
				goingto=/turf/WARPERHOMES/Sect18/C1
			D2
				goingto=/turf/WARPERHOMES/Sect18/C2

			E1
				goingto=/turf/WARPERHOMES/Sect18/F1
			E2
				goingto=/turf/WARPERHOMES/Sect18/F2
			F1
				goingto=/turf/WARPERHOMES/Sect18/E1
			F2
				goingto=/turf/WARPERHOMES/Sect18/E2





		newwarps
			in1
				goingto=/turf/WARPERHOMES/newwarps/out1
			out1
				goingto=/turf/WARPERHOMES/newwarps/in1


			in2
				goingto=/turf/WARPERHOMES/newwarps/out2
			out2
				goingto=/turf/WARPERHOMES/newwarps/in2

			in3
				goingto=/turf/WARPERHOMES/newwarps/out3
			out3
				goingto=/turf/WARPERHOMES/newwarps/in3

			in4
				goingto=/turf/WARPERHOMES/newwarps/out4
			out4
				goingto=/turf/WARPERHOMES/newwarps/in4


			in5
				goingto=/turf/WARPERHOMES/newwarps/out5
			out5
				goingto=/turf/WARPERHOMES/newwarps/in5

			in6
				goingto=/turf/WARPERHOMES/newwarps/out6
			out6
				goingto=/turf/WARPERHOMES/newwarps/in6

			in7
				goingto=/turf/WARPERHOMES/newwarps/out7
			out7
				goingto=/turf/WARPERHOMES/newwarps/in7

			in8
				goingto=/turf/WARPERHOMES/newwarps/out8
			out8
				goingto=/turf/WARPERHOMES/newwarps/in8


			in9
				goingto=/turf/WARPERHOMES/newwarps/out9
			out9
				goingto=/turf/WARPERHOMES/newwarps/in9

			in10
				goingto=/turf/WARPERHOMES/newwarps/out10
			out10
				goingto=/turf/WARPERHOMES/newwarps/in10

			in11
				goingto=/turf/WARPERHOMES/newwarps/out11
			out11
				goingto=/turf/WARPERHOMES/newwarps/in11

			in12
				goingto=/turf/WARPERHOMES/newwarps/out12
			out12
				goingto=/turf/WARPERHOMES/newwarps/in12

			in13
				goingto=/turf/WARPERHOMES/newwarps/out13
			out13
				goingto=/turf/WARPERHOMES/newwarps/in13


		newwarp123
			ina
				goingto=/turf/WARPERHOMES/newwarp123/outa
			outa
				goingto=/turf/WARPERHOMES/newwarp123/ina
			inb
				goingto=/turf/WARPERHOMES/newwarp123/outb
			outb
				goingto=/turf/WARPERHOMES/newwarp123/inb
			inc
				goingto=/turf/WARPERHOMES/newwarp123/outc
			outc
				goingto=/turf/WARPERHOMES/newwarp123/inc
			ind
				goingto=/turf/WARPERHOMES/newwarp123/outd
			outd
				goingto=/turf/WARPERHOMES/newwarp123/ind




turf
	NoboruEnt
		density = 0
		Enter()
			usr.loc=locate(168,43,5)

	NoboruExt
		density = 0
		Enter()
			usr.loc=locate(255,145,2)

	AnbuEnt
		density = 0
		Enter()
			usr.loc=locate(65,2,11)

	AnbuExt
		density = 0
		Enter()
			usr.loc=locate(62,15,10)

	SnakeEnt
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/SnakeExt)
	SnakeExt
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/SnakeEnt)

turf/kiri
	layer = 1000
	h11
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h12)
	h12
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h11)
	h21
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h22)
	h22
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h21)
	h31
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h32)
	h32
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h31)
	h41
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h42)
	h42
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h41)
	h51
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h52)
	h52
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h51)
	h61
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h62)
	h62
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h61)
	h71
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h72)
	h72
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h71)
	h81
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h82)
	h82
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h81)
	h91
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h92)
	h92
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/h91)
	hh101
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/hh102)
	hh102
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/hh101)
	hh111
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/hh112)
	hh112
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/hh111)
	hh121
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/hh122)
	hh122
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/hh121)
	hh131
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/hh132)
	hh132
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/hh131)
	hh141
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/hh142)
	hh142
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/hh141)
	hh151
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/hh152)
	hh152
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/hh151)
	hh161
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/hh162)
	hh162
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/hh161)



	aca1
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/aca2)
	aca2
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/aca1)


	police1
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/police2)
	police2
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/police1)

	police1e
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/police2e)
	police2e
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/police1e)

	cs1
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/cs2)
	cs2
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/cs1)

	w1
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/w2)
	w2
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/w1)

	th11
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/th21)
	th21
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/th11)

	th12
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/th22)
	th22
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/th12)

	th13
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/th23)
	th23
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/th13)


	mkage1
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/mkage2)
	mkage2
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/kiri/mkage1)


turf/suna
	layer = 1000
	h11
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h12)
	h12
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h11)
	h21
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h22)
	h22
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h21)
	h31
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h32)
	h32
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h31)
	h41
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h42)
	h42
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h41)
	h51
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h52)
	h52
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h51)
	h61
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h62)
	h62
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h61)
	h71
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h72)
	h72
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h71)
	h81
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h82)
	h82
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h81)
	h91
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h92)
	h92
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/h91)


	aca1
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/aca2)
	aca2
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/aca1)


	police1
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/police2)
	police2
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/police1)

	police1e
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/police2e)
	police2e
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/police1e)

	cs1
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/cs2)
	cs2
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/cs1)

	w1
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/w2)
	w2
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/w1)



	kkage1
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/kkage2)
	kkage2
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/suna/kkage1)














turf/newsuna
	layer = 1000
	gen1
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/newsuna/gen2)
	gen2
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/newsuna/gen1)

	gen1a
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/newsuna/gen2a)
	gen2a
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/newsuna/gen1a)


	gen1b
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/newsuna/gen2b)
	gen2b
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/newsuna/gen1b)

	gen1b
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/newsuna/gen2b)
	gen2b
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/newsuna/gen1b)


	gen1c
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/newsuna/gen2c)
	gen2c
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/newsuna/gen1c)


	gen1d
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/newsuna/gen2d)
	gen2d
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/newsuna/gen1d)




	gen1e
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/newsuna/gen2e)
	gen2e
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/newsuna/gen1e)


	gen1f
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/newsuna/gen2f)
	gen2f
		Entered(mob/M)
			if(istype(M,/mob))
				M.loc=locate(/turf/newsuna/gen1f)