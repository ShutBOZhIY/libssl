# Building OpenSSL

**NOTE: This project is still a work in progress**. It's just started to
be useful for me so I started hosting it.

Building OpenSSL is a pain. Especially for any platform besides Linux.

Let's fix that.

Extact an openssl release tarbar into the folder
openssl_tarball. The file openssl_tarball/Makefile
should exist. If it doesn't you did something wrong.

Use premake4 to generate your project file:

`premake4 vs2008`

Open your project file:

`.build\projects\libssl.sln`

Build.

The public includes for OpenSSL are in the `include/` folder while your static libraries are in `lib`.

To clean up any build products, simply rerun premake4 with "clean" as the action:

`premake4 clean`

or use git:

`git clean -df`

Contact
-------
[@MatthewEndsley](https://twitter.com/#!/MatthewEndsley)  
<https://github.com/mendsley/libssl>

License
-------
For OpenSSL see [http://www.openssl.org/source/license.html](http://www.openssl.org/source/license.html).

My contributions (this git repsository) are released under the BSD 2-clause license (see LICENSE).  This only applies if you want to distribute the lua files.  You're free to distribute the OpenSSL libraries, headers, and projects using either under the terms of the OpenSSL licenses without  crediting me.

premake4
--------
Copyright (c) 2003-2012 Jason Perkins and individual contributors.
All rights reserved.

Binaries are distributed under the BSD-3 clause license (see LICENSE_premake4).

See [http://industriousone.com/premake](http://industriousone.com/premake) for
details.