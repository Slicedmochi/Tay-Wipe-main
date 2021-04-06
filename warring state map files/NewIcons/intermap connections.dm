//avainer
var/worldTravelLimit = 36000 // One Hour

mob/Admin3/verb/changeTravelLimit()
	set category = "Admin"
	worldTravelLimit = input("Input the number of minutes between map changes: ") as num
	worldTravelLimit = worldTravelLimit * 600
	 //60 minutes * 60 seconds * 10
turf/warringStateWarper
	var
		exitx;exity;exitz
	zOneSouth
		exitx = 0
		exity = 299
		exitz = 15

	zOneEast
		exitx = 2
		exity = 0
		exitz = 3

	zOneWest
		exitx = 299
		exity = 0
		exitz = 24

	zOneNorth
		exitx = 0
		exity = 2
		exitz = 13

	zThreeSouth
		exitx = 0
		exity = 299
		exitz = 22

	zThreeWest
		exitx = 299
		exity= 0
		exitz= 1

	zThreeEast
		exitx = 2
		exity= 0
		exitz= 18
	zThreeNorth
		exitx = 0
		exity = 2
		exitz= 5
	zFiveSouth
		exitx = 0
		exity = 299
		exitz = 3
	zFiveWest
		exitx = 299
		exity = 0
		exitz = 13


	zSevenSouth
		exitx = 0
		exity = 299
		exitz= 13

	zNineEast
		exitx = 2
		exity = 0
		exitz = 24

	zNineNorth
		exitx = 0
		exity = 2
		exitz= 28



	zElevenSouth
		exitx = 0
		exity = 299
		exitz = 24

	zElevenEast
		exitx = 2
		exity = 0
		exitz = 13


	z13South
		exitx = 0
		exity = 299
		exitz = 1

	z13East
		exitx = 2
		exity = 0
		exitz = 5

	z13West
		exitx = 299
		exity = 0
		exitz = 11

	z13North
		exitx = 0
		exity = 2
		exitz = 7

	z15South
		exitx = 0
		exity = 299
		exitz = 17

	z15East
		exitx = 2
		exity = 0
		exitz = 22

	z15West
		exitx = 299
		exity = 0
		exitz = 20

	z15North
		exitx = 2
		exity = 0
		exitz = 1

	z17North
		exitx=0
		exity=2
		exitz=15

	z18West
		exitx = 299
		exity=0
		exitz=3

	z20North
		exitx= 0
		exity= 2
		exitz= 24
	z20East
		exitx = 2
		exity= 0
		exitz= 15


	z22West
		exitx = 299
		exity= 0
		exitz=15

	z22North
		exitx=0
		exity=2
		exitz=3
	z24South
		exitx = 0
		exity = 299
		exitz = 20

	z24East
		exitx = 2
		exity = 0
		exitz = 1

	z24West
		exitx = 299
		exity = 0
		exitz = 9

	z24North
		exitx = 0
		exity = 2
		exitz = 11

	z28South
		exitx = 0
		exity = 299
		exitz = 9




	Entered(mob/M)
		if(istype(M, /mob/))
			if(M.teleporting) return
			if(M.client)
			//(istype(M,/mob/Clone/) || istype(M,/mob/Bunshin/) || istype(M,/mob/RaitonBunshin/) || istype(M,/mob/OboroBunshin/) || istype(M,/mob/KatonBunshin/) || istype(M,/mob/KageBunshin/) || istype(M,/mob/TsuchiBunshin/)))
				var/limit = worldTravelLimit
				for(var/obj/jutsu/perk in M)
					if(perk.name == "Courier")
						limit = worldTravelLimit / 2
						break

				if( (world.realtime - M.crossTime) < limit)

					if(M.MindTransfer) if(M == M.MindTransfer.MindAfflicted) return
					if(M.MindAfflicted)
						M.MindAfflicted<<output("<font size = -3>You need to wait atleast [limit/(36000)] hour(s) before moving maps again!","outputic.output")
						M.MindAfflicted<<output("<font size = -3>You need to wait atleast [limit/(36000)] hour(s) before moving maps again!","outputall.output")
					else
						M<<output("<font size = -3>You need to wait atleast [limit/(36000)] hour(s) before moving maps again!","outputic.output")
						M<<output("<font size = -3>You need to wait atleast [limit/(36000)] hour(s) before moving maps again!","outputall.output")
					return


				for(var/mob/X in world)
					if(X.name==M.grabbee || X.grabber==usr.name)
						if((world.realtime - X.crossTime) < worldTravelLimit)
							X.crossTime = world.realtime
							X.grabber=null
							M.grabbee=null
							M.attacking=0
							X.pixel_y=0
							X.pixel_x=0


				M.teleporting = 1
				M.density = 0
				var/xx = exitx
				var/yy = exity
				if(exitx == 0) xx = src.x
				if(exity == 0) yy = src.y
				M.Move(locate(xx,yy,exitz))
				M.density = 1
				if(M.chakraOverlay) M.chakraOverlay.loc = M.loc
				M.teleporting = 0
				M.overlays -= 'Swim.dmi'
				M.swim=0
				M.crossTime = world.realtime