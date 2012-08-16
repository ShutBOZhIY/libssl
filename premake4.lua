dofile "premake/platforms.lua"
dofile "premake/library.lua"

solution "libssl"
	local ROOT_DIR = path.getdirectory(_SCRIPT) .. "/"
	local OPENSSL_DIR = ROOT_DIR .. "openssl_tarball/"
	
	configurations {
		"release"
	}
	
	platforms {
		"x32",
		"x64",
		"native",
	}
	
	location (ROOT_DIR .. ".build/projects/")
	objdir (ROOT_DIR .. ".build/obj/")
	targetdir (ROOT_DIR .. "lib/")
	
	defines {
		"OPENSSL_NO_DYNAMIC_ENGINE",
		"OPENSSL_NO_ASM",
		"OPENSSL_NO_RC5",
		"OPENSSL_NO_MD2",
		"OPENSSL_NO_KRB5",
		"OPENSSL_NO_JPAKE",
		"OPENSSL_NO_STORE",
		"NO_WINDOWS_BRAINDEATH",
	}
	
	flags {
		"Symbols"
	}
	
	configuration { "vs*" }
		defines {
			"OPENSSL_SYSNAME_WIN32",
			"WIN32_LEAN_AND_MEAN",
			"L_ENDIAN",
			"_CRT_SECURE_NO_DEPRECATE",
		}
	
	configuration {"x32", "vs*"}
		defines {
			"PLATFORM=\\\"VC-WIN32\\\"",
		}	
	configuration {"x64", "vs*"}
		defines {
			"PLATFORM=\\\"VC-WIN64A\\\"",
		}
		
	configuration {}
	
	-- Libraries explicitly excluded
	local excluded_libs = {
		"crypto/store",
		"crypto/jpake",
		"crypto/rc5",
		"crypto/md2",
		"crypto/krb5",
	}

	local libraries = generate_libraries(OPENSSL_DIR)
	local crypto_source = {}
	local ssl_source = {}
	
	function copyheaders()
		print("Copying public headers to include/openssl")
		os.rmdir(ROOT_DIR .. "include/openssl")
		os.rmdir(ROOT_DIR .. ".build/privinclude")
		os.mkdir(ROOT_DIR .. "include/openssl")
		os.mkdir(ROOT_DIR .. ".build/privinclude")
		
		local libname, lib, header, source
		for libname, lib in pairs(libraries) do
			for _, header in ipairs(lib.public_headers) do
				os.copyfile(OPENSSL_DIR .. libname .. "/" .. header, ROOT_DIR .. "include/openssl/" .. header)
			end
			
			if not library_excluded(libname, excluded_libs) then
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
	
	if _ACTION ~= "clean" then
		copyheaders()
	else
		os.rmdir(ROOT_DIR .. "include")
		os.rmdir(ROOT_DIR .. "lib")
		os.rmdir(ROOT_DIR .. ".build")
	end

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
