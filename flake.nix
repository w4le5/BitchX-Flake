{ stablePkgs }:

stablePkgs.stdenv.mkDerivation {
	pname = "bitchx";
	version = "1.3";

	src = stablePkgs.fetchFromGitHub {
		owner = "BitchX";
		repo = "BitchX1.3";
		rev = "master";
		sha256 = "0i5wk09h6p9aip9abw147y9xsgsi718vbw2ydmvm94mcfbs7q8gd";
	};

	dontSetConfigureFlags = true;

	nativeBuildInputs = with stablePkgs; [
		autoconf automake libtool pkg-config gnumake gettext cpio
	];

	buildInputs = with stablePkgs; [
		ncurses openssl zlib libxcrypt
	];

	hardeningDisable = [ "fortify" ];

	NIX_CFLAGS_COMPILE = "-Wno-error=format-security -Wno-error=stringop-overflow";

	configurePhase = ''
		if [ -x ./autogen.sh ]; then
			./autogen.sh
		else
			autoreconf -fi
		fi

		find . -type f -name "Makefile*" -exec sed -i 's/-Werror//g' {} +

		./configure --prefix=$out --with-ssl --enable-ipv6 LDFLAGS="-lcrypt"
	'';

	buildPhase = ''
		make LDFLAGS="-lcrypt"
	'';

	installPhase = "make install";

	meta = with stablePkgs.lib; {
		description = "Classic terminal-based IRC client (ircII fork)";
		homepage = "https://github.com/BitchX/BitchX1.3";
		license = licenses.gpl2Plus;
		platforms = platforms.unix;
	};
}
