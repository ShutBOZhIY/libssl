-------------------------------------------------------------------------------
-- OpenSSL settings for compiler/platform
-------------------------------------------------------------------------------

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
		"SIXTY_FOUR_BIT",
	}


-- End of configurations	
configuration {}
