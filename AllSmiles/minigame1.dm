obj/minigame/checkers/black
	var/skillname= "Custom no Jutsu"
	var/skillicon= 'Bunshin.dmi'
	var/skillobj="Custom "
	icon='Skillcard.dmi'
	icon_state="Bunshin"
	Click()
		if(src in usr.contents)
			var/bunshins=0
			if(!usr.move)
				return
			for(var/mob/Bunshin/Z)
				if(Z.displaykey==usr.key)
					bunshins+=1
			if(bunshins<bunshinskill)
				usr.Jutsu_Gain()
				usr.MaxGenjutsu += (1 *0.001)
				usr.Chakra-=usr.MaxChakra*(0.5/bunshinskill)
				src.Active=1
				var/mob/A=new/mob/Bunshin
				viewers(16) << "<font color=[usr.SayFont]>[usr] "
				A.Savable=0
				var/random=rand(1,4)
				if(random==1)
					A.loc=locate(usr.x-1,usr.y,usr.z)
				if(random==2)
					A.loc=locate(usr.x+1,usr.y,usr.z)
				if(random==3)
					A.loc=locate(usr.x,usr.y-1,usr.z)
				if(random==4)
					A.loc=locate(usr.x,usr.y+1,usr.z)
				A.name="[skillobj]"
				A.move=1
				A.icon= skillicon

				sleep(15)
				src.Active=0
			else
			 usr<<"You do not have the skill to create this many."






obj/Board
	icon='BOARDGAMEBOARD.dmi'
	density=1
	opacity=1
	var/Master="None"
	var/Challenger=""
	var/haschallenger=0
	var/readyup=
	var/room
	Click()
		lala
		if(src.Master=="None")
			src.Master= "[usr]"
			usr.master=1
			src.readyup=1
			switch(input("Please select a Lobby number") in list ("One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten","Eleven","Tweleve","Thirteen","Fourteen","Fithteen","Sixteen","Seventeen","Eighteen","Nineteen","Twenty"))



/*
	var/inuse=0
	var/player=0
	var/lastplace=0
	Click()


/*		if(src.inuse)
			return
		else
			src.inuse=1
			var/list/Choices=new/list
			Choices.Add("Game Mode")
			Choices.Add("Invite Player")
			Choices.Add("")
			Choices.Add("Cancel")
			switch(input("Choose Option","",text) in Choices)
				if("Game Mode")
					var/list/gmode=new/list
					gmode.Add("Checkers")
					gmode.Add("Chess")
					gmode.Add("Shogi")
					gmode.Add("Cancel")
					switch(input("Choose Gametype","",text) in gmode)
						if("Checkers")
						if("Chess")
				h		if("Shogi")
						if("Cancel")
							return
				if("Invite Player")
				if("Stay")
				if("Attack Target")
				if("Juujin Bunshin")*/
