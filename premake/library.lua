function split_words(line)
	local words = {}
	local word
	for word in line:gmatch("%S+") do
		table.insert(words, word)
	end
	return words
end

function library_excluded(libname, excluded)
	for _, v in ipairs(excluded) do
		if v == libname then
			return true
		end
	end
	return false
end

function parse_library(pathToMakefile)
	local lib = {
		public_headers={},
		private_headers={},
		source={},
	}
	local f = assert(io.open(pathToMakefile))
	while true do
		local line = f:read("*line")
		if not line then break end
		while string.sub(line, string.len(line)) == "\\" do
			line = string.sub(line, 1, string.len(line) - 1)
			line = line .. f:read("*line")
		end
		if string.sub(line, 1, 9) == "EXHEADER=" then
			lib.public_headers = split_words(line:sub(10))
		elseif string.sub(line, 1, 7) == "HEADER=" then
			lib.private_headers = split_words(line:sub(8))
		elseif string.sub(line, 1, 7) == "LIBSRC=" then
			lib.source = split_words(line:sub(8))
		end
	end
	f:close()
	
	local idex, header, pheader
	for idx, header in ipairs(lib.private_headers) do
		if header == "$(EXHEADER)" then
			lib.private_headers[idx] = nil
			for _, pheader in ipairs(lib.public_headers) do
				table.insert(lib.private_headers, pheader)
			end
			break
		end
	end

	return lib
end

function generate_libraries(OPENSSL_DIR, excluded_libs)
	local libraries = {}
	print("Finding libraries...")
	for _, makefile in ipairs(os.matchfiles(OPENSSL_DIR .. "crypto/**/Makefile")) do
		local libname = string.gsub(path.getdirectory(makefile), OPENSSL_DIR .. "crypto/", "")
		if not library_excluded("crypto/" .. libname, excluded_libs) then
			libraries["crypto/"..libname] = parse_library(makefile)
		end
	end
	libraries["crypto"] = parse_library(OPENSSL_DIR .. "crypto/Makefile")
	libraries[""] = parse_library(OPENSSL_DIR .. "Makefile")
	return libraries
end
