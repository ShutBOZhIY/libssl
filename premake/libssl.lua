local ROOT_DIR = path.getdirectory(_SCRIPT) .. "/../"
local OPENSSL_DIR = ROOT_DIR .. "openssl_tarball/"

local libraries = {}
local crypto_source = {}
local ssl_source = {}

function copyheaders()
	print("Copying public headers to include/openssl")
	os.mkdir(ROOT_DIR .. "include/openssl")
	os.mkdir(ROOT_DIR .. ".build/privinclude")
	
	local libname, lib, header, source
	for libname, lib in pairs(libraries) do
		for _, header in ipairs(lib.public_headers) do
			os.copyfile(OPENSSL_DIR .. libname .. "/" .. header, ROOT_DIR .. "include/openssl/" .. header)
		end
		
		if not library_excluded(libname, config.excluded_libs, "crypto/") then
			for _, header in ipairs(lib.private_headers) do
				os.copyfile(OPENSSL_DIR .. libname .. "/" .. header, ROOT_DIR .. ".build/privinclude/" .. header)
			end
			for _, source in ipairs(lib.source) do
				if libname == "ssl" then
					table.insert(ssl_source, OPENSSL_DIR .. libname .. "/" .. source)
				else
					table.insert(crypto_source, OPENSSL_DIR .. libname .. "/" .. source)
				end
			end
		end
	end
end
	
local config_defines = {}
local config_define_mapping = {
	dynamic_engine="DYNAMIC_ENGINE",
	asm="ASM",
	gmp="GMP",
	ec_nistp_64_gcc_128="EC_NISTP_64_GCC_128",
	rfc3779="RFC3779",
	sctp="SCTP",
}

function update_defines()
	local libname, name, value
	
	for _, libname in ipairs(config.excluded_libs) do
		table.insert(config_defines, "OPENSSL_NO_" .. string.upper(libname))
	end
	
	for name, value in ipairs(config_define_mapping) do
		if not config["name"] then
			table.insert(config_defines, "OPENSSL_NO_" .. value)
		end
	end
end

function fixup_configheader()
	local function fix(filepath)
		local libname, key, value
		local f = assert(io.open(filepath, "r"))
		local lines = {}
		
		local todisable = {}
		for _, libname in ipairs(config.excluded_libs) do
			todisable[libname] = true
		end
		
		while true do
			local line = f:read("*line")
			if not line then break end
			local words = split_words(line)
			if #words == 3 and words[1] == "#" and words[2] == "define" and string.sub(words[3], 1, 11) == "OPENSSL_NO_" then
				local define = string.sub(words[3], 12)
				
				-- disabled project we've enabled?
				local enable = true
				for _, libname in ipairs(config.excluded_libs) do
					if define == string.upper(libname) then
						todisable[libname] = nil
						enable = false
						break
					end
				end
				
				--disabled config we've enabled?
				for key, value in pairs(config_define_mapping) do
					if define == value and not config[key] then
						enable = false
						break
					end
				end
				
				if enable then
					line = "/* (Enabled via premake config.lua) " .. line .. " */"
				end
			end
			

			table.insert(lines, line)
		end
		f:close()
		
		f = assert(io.open(filepath, "w"))
		for _, line in ipairs(lines) do				
			f:write(line.."\n")

			local words = split_words(line)
			if #words == 2 and words[1] == "#ifndef" and words[2] == "OPENSSL_DOING_MAKEDEPEND" then
				for libname, _ in pairs(todisable) do
					f:write("/* " .. string.upper(libname) .. " disabled via premae config.lua */\n")
					f:write("#ifndef OPENSSL_NO_" .. string.upper(libname) .. "\n")
					f:write("# define OPENSSL_NO_" .. string.upper(libname) .. "\n")
					f:write("#endif\n")
				end
			end
		end
		f:close()
	end
	
	fix(ROOT_DIR .. "include/openssl/opensslconf.h")
	fix(ROOT_DIR .. ".build/privinclude/opensslconf.h")
end

if _ACTION then
	os.rmdir(ROOT_DIR .. "include")
	os.rmdir(ROOT_DIR .. ".build")

	if _ACTION ~= "clean" then
		libraries = generate_libraries(OPENSSL_DIR)
		update_defines()
		copyheaders()
		fixup_configheader()
	end
end

defines {
	"NO_WINDOWS_BRAINDEATH",
	config_defines,
}

dofile (ROOT_DIR .. "premake/configuration.lua")

project "crypto"
	language "C"
	kind "StaticLib"

	includedirs {
		ROOT_DIR .. "include/",
		ROOT_DIR .. ".build/privinclude",
	}

	files {
		ROOT_DIR .. "include/openssl/**.h",
		ROOT_DIR .. ".build/privinclude/**.h",
		crypto_source
	}

project "ssl"
	language "C"
	kind "StaticLib"
	
	includedirs {
		ROOT_DIR .. "include/",
		ROOT_DIR .. ".build/privinclude",
	}
	
	files {
		ROOT_DIR .. "include/openssl/**.h",
		ROOT_DIR .. ".build/privinclude/**.h",
		ssl_source
	}
