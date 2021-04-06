/proc/file_log(msg, file_id)
	var/files = file_sort(file_id)
	if(!files)
		var/list/folder = flist("[pathlog]/[file_id]/")
		if(!folder.len)
			var/newfile = "[pathlog]/[file_id]/[file_id]1.txt"
			files = newfile
	files = file(files)
	files << msg+"<br>"

/proc/file_sort(file_id, out=1)
	var/list/files = list()
	var/list/folder = flist("[pathlog]/[file_id]/")
	if(!folder.len)
		return 0
	for(var/x in folder)
		var/y = text2num(copytext(x,length(file_id)+1,findtext(x,".txt")))
		if(y > files.len)
			files.len = y
		files[y] = x

		if(y == files.len)
			if(length(file("[pathlog]/[file_id]/[x]")) >= 1024*100)
				files.len++
				var/newfile = file("[file_id][files.len].txt")
				files[files.len] = newfile
	if(out==1)
		return "[pathlog]/[file_id]/[files[files.len]]"
	else return files