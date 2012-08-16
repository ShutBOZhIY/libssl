local ROOT_DIR = path.getdirectory(_SCRIPT) .. "/../"
dofile (ROOT_DIR .. "premake/common.lua")

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
