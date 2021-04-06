/********************************************/
/******** Coded by jOrDaN 24 Nov 2020 ********/
/********************************************/
archive
    var/discordinvite = "https://discord.gg/8GscvtACYN"
    var/updatever = 0.1
    var/stat_limit_reducer = 4
    var/check_threshold = 100
    var/TravelTimer = 600
//debug
/mob/verb/changereducer()
    set category = "Debug"
    archive.stat_limit_reducer = input(src, "?" , "?") as num
