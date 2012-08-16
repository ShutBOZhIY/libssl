function newplatform(plf)
	local name = plf.name
	local description = plf.description

	premake.platforms[name] = {
		cfgsuffix = "_"..name,
		iscrosscompiler = true,
	}

	table.insert(premake.option.list["platform"].allowed, {name, description})
	table.insert(premake.fields.platforms.allowed, name)

	premake.gcc.platforms[name] = plf.gcc
end

newplatform {
	name = "nacl32",
	description = "Chrome NativeClient",
	gcc = {
		cc = "x86_64-nacl-gcc",
		cxx = "x86_64-nacl-g++",
		ar = "x86_64-nacl-ar",
		cppflags = "-MMD -m32",
	}
}

newplatform {
	name = "nacl64",
	description = "Chrome 64bit NativeClient",
	gcc = {
		cc = "x86_64-nacl-gcc",
		cxx = "x86_64-nacl-g++",
		ar = "x86_64-nacl-ar",
		cppflags = "-MMD -m64",
	}
}
