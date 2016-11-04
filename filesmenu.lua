require('lfs')

function ls(dir)
	local iter, dir_obj = lfs.dir(dir)
	local files = { }
	local directories = { }
	local line = dir_obj:next()

	while line ~= nil do
		if lfs.attributes( dir .. '/' .. line, 'mode') == 'directory' and string.sub(line,1,1) ~= '.' then
			table.insert(directories,line .. '/')
		elseif string.sub(line,1,1) ~= '.' then 
			table.insert(files,line)
		end
		line = dir_obj:next()
	end
	dir_obj:close()
	return files,directories,dir
end

filters = {  
	{ {'.mkv','.avi'},'smplayer'},
	{ {'.pdf'},'evince' },
	{ {'.djvu'}, 'djview' },
	{ {'.png','.jpeg','.jpg','.gif'} , 'geeqie'},
	{ {'.odt'}, 'wps' },
	{ {'.*'}, 'geany' }
}	

function action(file,filters)
	for i=1,#filters do
		for j=1,#filters[i][1] do
			if string.match(file,filters[i][1][j]) ~= nil then
				return filters[i][2] .. ' '
			end
		end
	end
end

function parse(files,directories,dir)
	local result = { }
	for i=1,#directories do
		table.insert(result, { directories[i], parse(ls(dir .. directories[i])) })
	end
	for i=1,#files do
		table.insert(result, { files[i], action(files[i],filters) .. string.gsub(dir .. files[i],' ','\\ ') })
	end
	return result
end

function genMenu(dir)
	return parse(ls(dir))
end
