mob/verb/resized()
	set hidden = 1
	if(!client) return
	var/size = winget(src, "mappane", "size")
	if(!client) return
	var/width = text2num(copytext(size, 1, findtext(size, "x", 1, length(size) + 1)))
	var/height = text2num(copytext(size, findtext(size, "x", 1, length(size) + 1) + 1, length(size) + 1))
	client.view = "[round(width/32) + 1]x[round(height/32) + 1]"
	if(jutsu_box)
		jutsu_box.center(src)
	if(character_box)
		character_box.center(src)
	if(progress_box)
		progress_box.center(src)
	if(appearance_box)
		appearance_box.center(src)

mob/verb/closeProfile()
	set hidden=1
	src<<browse(null,"window=Profile.ProfileBrowse")
	winshow(src,"Profile",0)

mob/proc/get_client_height()
	var/size = client.view
	if(isnum(size))
		return size
	var/height = text2num(copytext(size, findtext(size, "x", 1, length(size) + 1) + 1, length(size) + 1))
	return height

mob/proc/get_client_width()
	var/size = client.view
	if(isnum(size))
		return size
	var/width = text2num(copytext(size, 1, findtext(size, "x", 1, length(size) + 1)))
	return width

mob/proc/load_resources()
	return
	for(var/msg in archive.button_icons)
		src << browse_rsc(archive.button_icons["[msg]"], "header_[archive.button_icons.Find(msg)].png")
		alert("header_[archive.button_icons.Find(msg)].png")
	/*src << browse_rsc('http://image.ibb.co//hn9erU/buttonall1.png')
	src << browse_rsc('http://image.ibb.co/kt63J9/buttonall2.png')
	src << browse_rsc('http://image.ibb.co/bXLkWU/buttonall3.png')
	src << browse_rsc('http://image.ibb.co/dr2zrU/buttonic1.png')
	src << browse_rsc('http://image.ibb.co/joHAy9/buttonic2.png')
	src << browse_rsc('http://image.ibb.co/eo8uQp/buttonic3.png')
	src << browse_rsc('http://image.ibb.co/nC415p/buttonooc1.png')
	src << browse_rsc('http://image.ibb.co/dpZ15p/buttonooc2.png')
	src << browse_rsc('http://image.ibb.co/fY9qy9/buttonooc3.png')
	src << browse_rsc('http://image.ibb.co/fcnjap/buttoncommand1.png')
	src << browse_rsc('http://image.ibb.co/e7gAFp/buttoncommand2.png')
	src << browse_rsc('https://image.ibb.co/bXiiJ9/buttonsay1.png')
	src << browse_rsc('https://image.ibb.co/cKnokp/buttonsay2.png')
	src << browse_rsc('https://image.ibb.co/g6KZQp/buttonroleplay1.png')
	src << browse_rsc('https://image.ibb.co/eh7okp/buttonroleplay2.png')
	src << browse_rsc('https://image.ibb.co/fQjCBU/buttonwhisper1.png')
	src << browse_rsc('https://image.ibb.co/dN35WU/buttonwhisper2.png')
	src << browse_rsc('https://image.ibb.co/hkNAy9/alertbutton1.png')
	src << browse_rsc('https://image.ibb.co/kjccd9/alertbutton2.png')
	src << browse_rsc('https://image.ibb.co/mY2tJ9/confirmbutton1.png')
	src << browse_rsc('https://image.ibb.co/kmnhBU/confirmbutton2.png')
	sleep()*/

mob/proc/skin_show_tabs()
	src << output("[skin_tab["html"]][skin_tab["alltab"]]</body><html>", "mainscreen.tabs")



mob/proc/skin_show_input()
	//src << browse_rsc('http://image.ibb.co/fcnjap/buttoncommand1.png')
	//src << browse_rsc('http://image.ibb.co/e7gAFp/buttoncommand2.png')
	//src << browse_rsc('https://image.ibb.co/bXiiJ9/buttonsay1.png')
	//src << browse_rsc('https://image.ibb.co/cKnokp/buttonsay2.png')
	//src << browse_rsc('https://image.ibb.co/g6KZQp/buttonroleplay1.png')
	//src << browse_rsc('https://image.ibb.co/eh7okp/buttonroleplay2.png')
	//src << browse_rsc('https://image.ibb.co/fQjCBU/buttonwhisper1.png')
	//src << browse_rsc('https://image.ibb.co/dN35WU/buttonwhisper2.png')
	src << output("[skin_tab["html"]][skin_input["buttoncommand"]]</body><html>", "childchat.input")

mob/proc/button_show_input()
	var/html = {"
	<html>
	<style>
	html, body, img { margin:0px; padding:0px; overflow:hidden; cursor:pointer; }
	</style>
	<body>
	"}

	//src << browse_rsc('https://image.ibb.co/hkNAy9/alertbutton1.png')
	//src << browse_rsc('https://image.ibb.co/kjccd9/alertbutton2.png')
	//src << browse_rsc('https://image.ibb.co/mY2tJ9/confirmbutton1.png')
	//src << browse_rsc('https://image.ibb.co/kmnhBU/confirmbutton2.png')
	//src << browse_rsc('https://image.ibb.co/b8Lxd9/bigyes1.png')
	//src << browse_rsc('https://image.ibb.co/mBxM5p/bigyes2.png')
	//src << browse_rsc('https://image.ibb.co/krPCBU/bigno1.png')
	//src << browse_rsc('https://image.ibb.co/cXREQp/bigno2.png')
	src << output("[html]<img style='position:absolute; left:0px; top:0px;' src=https://i.ibb.co/DLQ2fmP/sealbutton.png onmouseover=this.src='https://i.ibb.co/87V8kj6/sealbuttonpressed.png' onmouseout=this.src='https://i.ibb.co/DLQ2fmP/sealbutton.png' onclick=window.location='byond://?value=inputconfirm'></body><html>", "alert4.button")
	src << output("[html]<img style='position:absolute; left:0px; top:0px;' src=https://image.ibb.co/hkNAy9/alertbutton1.png onmouseover=this.src='https://image.ibb.co/kjccd9/alertbutton2.png' onmouseout=this.src='https://image.ibb.co/hkNAy9/alertbutton1.png' onclick=window.location='byond://?value=alertconfirm'></body><html>", "StatueViewer.button")
	src << output("[html]<img style='position:absolute; left:0px; top:0px;' src=https://image.ibb.co/hkNAy9/alertbutton1.png onmouseover=this.src='https://image.ibb.co/kjccd9/alertbutton2.png' onmouseout=this.src='https://image.ibb.co/hkNAy9/alertbutton1.png' onclick=window.location='byond://?value=alertconfirm'></body><html>", "alert.button")
	src << output("[html]<img style='position:absolute; left:0px; top:0px;' src=https://image.ibb.co/hkNAy9/alertbutton1.png onmouseover=this.src='https://image.ibb.co/kjccd9/alertbutton2.png' onmouseout=this.src='https://image.ibb.co/hkNAy9/alertbutton1.png' onclick=window.location='byond://?value=alertconfirm'></body><html>", "alert_html.button")

	//src << output("[html]<img style='position:absolute; left:0px; top:0px;' src=https://image.ibb.co/b8Lxd9/bigyes1.png onmouseover=this.src='http://s10.postimg.org/o2y4upq7d/https://image.ibb.co/mBxM5p/bigyes2.png' onmouseout=this.src='https://image.ibb.co/b8Lxd9/bigyes1.png' onclick=window.location='byond://?value=alertyes'></body><html>", "bigalert1.buttonyes")
	//src << output("[html]<img style='position:absolute; left:0px; top:0px;' src=https://image.ibb.co/krPCBU/bigno1.png onmouseover=this.src='https://image.ibb.co/cXREQp/bigno2.png' onmouseout=this.src='https://image.ibb.co/krPCBU/bigno1.png' onclick=window.location='byond://?value=alertno'></body><html>", "bigalert1.buttonno")





var/skin_tab = list(
"html" = {"
<html>
<style>
html, body, img { margin:0px; padding:0px; overflow:hidden; }
</style>
<script type="text/javascript">
function replace(v) {
  document.body.innerHTML = v; }
</script>
<body>
"},

"alltab" = {"
<img style='cursor:default; position:absolute; left:0px; top:0px;' src=http://image.ibb.co/bXLkWU/buttonall3.png>
<img style='cursor:pointer; position:absolute; left:77px; top:1px;' src=http://image.ibb.co/dr2zrU/buttonic1.png onmouseover=this.src='http://image.ibb.co/joHAy9/buttonic2.png' onmouseout=this.src='http://image.ibb.co/dr2zrU/buttonic1.png' onclick=window.location='byond://?value=ictab'>
<img style='cursor:pointer; position:absolute; left:152px; top:1px;' src=http://image.ibb.co/nC415p/buttonooc1.png onmouseover=this.src='http://image.ibb.co/dpZ15p/buttonooc2.png' onmouseout=this.src='http://image.ibb.co/nC415p/buttonooc1.png' onclick=window.location='byond://?value=ooctab'>
"},

"ictab" = {"
<img style='cursor:default; position:absolute; left:0px; top:0px;' src=http://image.ibb.co/eo8uQp/buttonic3.png>
<img style='cursor:pointer; position:absolute; left:1px; top:1px;' src=http://image.ibb.co//hn9erU/buttonall1.png onmouseover=this.src='http://image.ibb.co/kt63J9/buttonall2.png' onmouseout=this.src='http://image.ibb.co//hn9erU/buttonall1.png' onclick=window.location='byond://?value=alltab'>
<img style='cursor:pointer; position:absolute; left:152px; top:1px;' src=http://image.ibb.co/nC415p/buttonooc1.png onmouseover=this.src='http://image.ibb.co/dpZ15p/buttonooc2.png' onmouseout=this.src='http://image.ibb.co/nC415p/buttonooc1.png' onclick=window.location='byond://?value=ooctab'>"},

"ooctab" = {"
<img style='cursor:default; position:absolute; left:0px; top:0px;' src=http://image.ibb.co/fY9qy9/buttonooc3.png>
<img style='cursor:pointer; position:absolute; left:77px; top:1px;' src=http://image.ibb.co/dr2zrU/buttonic1.png onmouseover=this.src='http://image.ibb.co/joHAy9/buttonic2.png' onmouseout=this.src='http://image.ibb.co/dr2zrU/buttonic1.png' onclick=window.location='byond://?value=ictab'>
<img style='cursor:pointer; position:absolute; left:1px; top:1px;' src=http://image.ibb.co//hn9erU/buttonall1.png onmouseover=this.src='http://image.ibb.co/kt63J9/buttonall2.png' onmouseout=this.src='http://image.ibb.co//hn9erU/buttonall1.png' onclick=window.location='byond://?value=alltab'>
"},

"current" = "alltab")




var/skin_input = list(
"html" = {"
<html>
<style>
html, body, img { margin:0px; padding:0px; overflow:hidden; }
</style>
<script type="text/javascript">
function replace(v) {
  document.body.innerHTML = v; }
</script>
<body>
"},

"buttoncommand" = {"
<img style='cursor:pointer; position:absolute; left:0px; top:0px;' src=http://image.ibb.co/fcnjap/buttoncommand1.png onmouseover=this.src='http://image.ibb.co/e7gAFp/buttoncommand2.png' onmouseout=this.src='http://image.ibb.co/fcnjap/buttoncommand1.png' onclick=window.location='byond://?value=buttonsay'>
"},

"buttonsay" = {"
<img style='cursor:pointer; position:absolute; left:0px; top:0px;' src=https://image.ibb.co/bXiiJ9/buttonsay1.png onmouseover=this.src='https://image.ibb.co/cKnokp/buttonsay2.png' onmouseout=this.src='https://image.ibb.co/bXiiJ9/buttonsay1.png' onclick=window.location='byond://?value=buttonroleplay'>
"},

"buttonroleplay" = {"
<img style='cursor:pointer; position:absolute; left:0px; top:0px;' src=https://image.ibb.co/g6KZQp/buttonroleplay1.png onmouseover=this.src='https://image.ibb.co/eh7okp/buttonroleplay2.png' onmouseout=this.src='https://image.ibb.co/g6KZQp/buttonroleplay1.png' onclick=window.location='byond://?value=buttonwhisper'>
"},

"buttonwhisper" = {"
<img style='cursor:pointer; position:absolute; left:0px; top:0px;' src=https://image.ibb.co/fQjCBU/buttonwhisper1.png onmouseover=this.src='https://image.ibb.co/dN35WU/buttonwhisper2.png' onmouseout=this.src='https://image.ibb.co/fQjCBU/buttonwhisper1.png' onclick=window.location='byond://?value=buttoncommand'>
"},

"current" = "buttoncommand")