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
	
configuration {"xbox360"}
	defines {
		"PLATFORM=\\\"VC-XBOX360\\\"",
		"B_ENDIAN",
	}


configuration {"nacl32"}
	defines {
		"PLATFORM=\\\"CHROME-NACL32\\\"",
		"L_ENDIAN",
		"TERMIO",
	}

configuration {"nacl64"}
	defines {
		"PLATFORM=\\\"CHROME-NACL64\\\"",
		"L_ENDIAN",
		"TERMIO",
	}
	
configuration {"mingw32"}
	defines {
		"PLATFORM=\\\"MINGW-WIN32\\\"",
		"L_ENDIAN",
		"WIN32_LEAN_AND_MEAN",
		"MINGW32",
	}

-- End of configurations	
configuration {}
