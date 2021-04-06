//total x of map + 1 - currentX
/mob/var/crossTime = 0
/mob/var/recentlycrossed = 0
/obj/Warper/
/obj/Warper/var/vertical = 0 // if it is vertical, change the bounds likely
/obj/Warper/var/tmp/mob/list/recent = list()
/obj/Warper/var/nextz = 1
//New Procs
/obj/Warper/New()
    ..()
    if(vertical)
        bound_width = world.maxx * 32
        bound_height = 32
    else
        bound_height= world.maxy * 32
        bound_width = 32
/obj/Warper/Crossed(atom/movable/thing)
    if(istype(thing, /mob/))
        var/mob/m = thing
        var/nextx
        var/nexty
        if(!m.client) return
        m.ChatLog("[m.name]([m.strangerName])([m.key]) tried to change maps.")
        var/limit = archive.TravelTimer
        if(m.find_perk("Courier"))
            limit /= 2
        if((world.realtime - m.crossTime) < limit)
            world<< "here"
            m._output("You need to wait another [limit/(600)] minute(s) before moving maps again!", "selfalert", "outputic.output")
            m._output("You need to wait another [limit/(600)] minute(s) before moving maps again!", "selfalert", "outputall.output")
            return
        if(vertical)
            nexty = world.maxy + 1 - m.y
            if(dir == 3)
                nexty = world.maxy - 1 - m.y
            nextx =  m.x
        else
            nextx = world.maxx + 1 - m.x
            nexty = m.y
        m.crossTime = world.realtime
        for(var/mob/x in ListOfPlayers())
            if(x.grabber == name)
                x.grabber = null
                m.attacking = 0
                x.pixel_y = 0
                x.pixel_x = 0
        m.teleporting = 1
        m.density = 0
        m.Move(locate(nextx,nexty,nextz))
        m.density = 1
        if(m.chakraOverlay) 
            m.chakraOverlay.loc = m.loc
        m.teleporting = 0
        m.ChatLog("[m.name]([m.strangerName])([m.key]) changed maps to [x],[y],[nextz]")
        recent += "[m.name]([m.strangerName]){[m.key]} | [time2text(world.realtime)]"
        if((world.realtime - m.crossTime) < 18000)
            m.recentlycrossed++
        else
            m.recentlycrossed = 0