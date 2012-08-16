local ROOT_DIR = path.getdirectory(_SCRIPT) .. "/"

dofile (ROOT_DIR .. "premake/platforms.lua")

solution "libssl"
	configurations {
		"release",
		"debug",
	}
	
	platforms {
		"x32",
		"x64",
		"native"
	}

	flags {
		"Symbols",
		"StaticRuntime"
	}

	local safeplatform = ""
	if _ACTION=="gmake" and not _OPTIONS["platform"] then
		print("Cannot build a gmake target without a platform from --platform")
		os.exit(1)
	end
	if _ACTION then
		safeplatform = _ACTION
		if _OPTIONS["platform"] then
			safeplatform = _ACTION .. "_" .. _OPTIONS["platform"]
		end
	end


	location (ROOT_DIR .. ".build/projects/" .. safeplatform .. "/")
	objdir (ROOT_DIR .. ".build/obj/" .. safeplatform .. "/")


	configuration {"debug"}
		targetdir (ROOT_DIR .. "lib/" .. safeplatform .. "/debug/")
	configuration {"release"}
		targetdir (ROOT_DIR .. "lib/" .. safeplatform .. "/release/")
	configuration {"x64", "debug"}
		targetdir (ROOT_DIR .. "lib/" .. safeplatform .. "_x64/debug/")
	configuration {"x64", "release"}
		targetdir (ROOT_DIR .. "lib/" .. safeplatform .. "_x64/release/")
	configuration {"x32", "debug"}
		targetdir (ROOT_DIR .. "lib/" .. safeplatform .. "_x32/debug/")
	configuration {"x32", "release"}
		targetdir (ROOT_DIR .. "lib/" .. safeplatform .. "_x32/release/")
	configuration {}

dofile (ROOT_DIR .. "premake/libssl.lua")