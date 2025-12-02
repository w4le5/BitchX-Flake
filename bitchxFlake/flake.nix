{
  description = "BitchX IRC client";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"
      ];
    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.stdenv.mkDerivation {
            pname = "bitchx";
            version = "1.3";

            src = pkgs.fetchFromGitHub {
              owner = "BitchX";
              repo = "BitchX1.3";
              rev = "master";
              sha256 = "sha256-oqPWQ6YH6tz6RQwl2rjRUZK6IlpgxPjIJS1YBl1myVE=";
            };

            dontSetConfigureFlags = true;
            nativeBuildInputs = with pkgs; [ autoconf automake libtool pkg-config gcc gnumake gettext cpio ];
            buildInputs = with pkgs; [ ncurses openssl zlib libxcrypt ];
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

            meta = with pkgs.lib; {
              description = "Classic terminal-based IRC client (ircII fork)";
              homepage = "https://github.com/BitchX/BitchX1.3";
              license = licenses.gpl2Plus;
              maintainers = [];
              platforms = platforms.unix;
            };
          };
        });

      # overlay
      overlay = final: prev: {
        bitchx = self.packages.${final.system}.default;
      };
    };
}
