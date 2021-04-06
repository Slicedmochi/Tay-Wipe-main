turf
	Sabu
		Clanhouse
			layer=999
			density=0
			var/goingto
			Entered(mob/M)
				if(!ismob(M)) return
				if(M.teleporting) return


				M.teleporting = 1
				M.density = 0
				M.Move(locate(goingto))

				M.teleporting = 0
				M.density = 1
			Exited()
				usr.layer=initial(usr.layer)
			EntranceExit
				EntranceL
					goingto=/turf/Sabu/Clanhouse/EntranceExit/ExitL
				EntranceR
					goingto=/turf/Sabu/Clanhouse/EntranceExit/ExitR

				ExitL
					goingto=/turf/Sabu/Clanhouse/EntranceExit/EntranceL
				ExitR
					goingto=/turf/Sabu/Clanhouse/EntranceExit/EntranceR