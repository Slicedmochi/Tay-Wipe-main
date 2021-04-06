mob/var/Log_Year=0
var/YearSpeed=10000

mob/var
	update2
	update1
proc/LoadYear()
	if(fexists("Saga/Year.sav"))
		var/savefile/F=new("Saga/Year.sav")
		F["Year"]>>archive.year
		F["Month"]>>archive.month
		F["Day"]>>archive.day
		F["YearSpeed"]>>YearSpeed

proc/SaveYear()
	var/savefile/F=new("Saga/Year.sav")
	F["Year"]<<archive.year
	F["Month"]<<archive.month
	F["Day"]<<archive.day
	F["YearSpeed"]<<YearSpeed

mob/Admin3
	verb
		DaySpeed()
			set category="Admin"
			set hidden = 1
			YearSpeed=input("Adjust year speed.","[YearSpeed]")as num
			if(YearSpeed<=1000)
				alert("Fuck you Rich")
				YearSpeed=1000
			if(src.key!="TiltHour") Admin_Logs+="<br>[usr]([usr.key]) adjusted the year speed to [YearSpeed]."
			SaveYear()
			SaveLogs()