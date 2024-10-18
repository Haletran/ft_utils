with import <nixpkgs> {};

let
    pkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/6e3a86f2f73a466656a401302d3ece26fba401d9.tar.gz";
    }) {};

    valgrind_3_18_1 = pkgs.valgrind;
in
stdenv.mkDerivation {
    name = "School";
    buildInputs = [
        pkgs.clang_12
        pkgs.gnumake
        valgrind_3_18_1
    ];
    shellHook = ''
        export CC=${pkgs.clang_12}/bin/clang
        export CXX=${pkgs.clang_12}/bin/clang++
        alias c++=${pkgs.clang_12}/bin/clang++
        alias cc=${pkgs.clang_12}/bin/clang

        echo "cc:  $(cc  --version)"
        echo "clang: $(clang --version)"
        echo "c++: $(c++ --version)"
        echo "make: $(make --version)"
    '';
}