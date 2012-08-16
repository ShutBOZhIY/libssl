-- Libraries explicitly excluded
config = {
	dynamic_engine = false,
	asm = false,
	gmp = false,
	ec_nistp_64_gcc_128 = false,
	rfc3779 = false,
	sctp = false,

	excluded_libs = {
		"store",
		"jpake",
		"rc5",
		"md2",
		"krb5",
	},
}
