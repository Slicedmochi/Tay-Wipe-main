/mob/proc/find_perk(n)
    for(var/obj/jutsu/jutsu in src)
        if(jutsu.name == n)
            return jutsu
    return FALSE
/mob/proc/get_perks()
    var/obj/jutsu/j = list()
    for(var/obj/jutsu/jutsu in src)
        if(jutsu.perk_type == "Gen2")
            j+=jutsu
    return j
/mob/proc/get_jutsus()
    var/obj/jutsu/j = list()
    for(var/obj/jutsu/jutsu in src)
        if(jutsu.perk_type != "Gen2")
            j+=jutsu
    return j