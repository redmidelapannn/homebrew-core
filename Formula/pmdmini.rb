class Pmdmini < Formula
  desc "Plays music in PC-88/98 PMD chiptune format"
  homepage "https://github.com/mistydemeo/pmdmini"
  url "https://github.com/mistydemeo/pmdmini/archive/v1.0.0.tar.gz"
  sha256 "526cb2be1a7e32be9782908cbaeae89b3aca20cad8e42f238916ce9b6d17679c"

  bottle do
    cellar :any
    rebuild 2
    sha256 "64cb146753c99395a447ec84d7ce6be769af6f508dfabfedc5b2cbcc6660bbec" => :sierra
    sha256 "deba5d3abb1cbb1dac84af8ea7d3f5176680df3fc0a53befec6fba38d171e650" => :el_capitan
    sha256 "3cc26a46054ac0a9afb5b22d3ad3e976601258604d9f578211f62c3ab1d2109f" => :yosemite
  end

  option "with-lib-only", "Do not build commandline player"
  deprecated_option "lib-only" => "with-lib-only"

  depends_on "sdl" if build.without? "lib-only"

  resource "test_song" do
    url "https://ftp.modland.com/pub/modules/PMD/Shiori%20Ueno/His%20Name%20Is%20Diamond/dd06.m"
    sha256 "36be8cfbb1d3556554447c0f77a02a319a88d8c7a47f9b7a3578d4a21ac85510"
  end

  def install
    # Specify Homebrew's cc
    inreplace "mak/general.mak", "gcc", ENV.cc
    if build.with? "lib-only"
      system "make", "-f", "Makefile.lib"
    else
      system "make"
    end

    # Makefile doesn't build a dylib
    system "#{ENV.cc} -dynamiclib -install_name #{lib}/libpmdmini.dylib -o libpmdmini.dylib -undefined dynamic_lookup obj/*.o"

    bin.install "pmdplay" if build.without? "lib-only"
    lib.install "libpmdmini.a", "libpmdmini.dylib"
    (include+"libpmdmini").install Dir["src/*.h"]
    (include+"libpmdmini/pmdwin").install Dir["src/pmdwin/*.h"]
  end

  test do
    resource("test_song").stage testpath
    (testpath/"pmdtest.c").write <<-EOS.undent
    #include <stdio.h>
    #include "libpmdmini/pmdmini.h"

    int main(int argc, char** argv)
    {
        char title[1024];
        pmd_init();
        pmd_play(argv[1], argv[2]);
        pmd_get_title(title);
        printf("%s\\n", title);
    }
    EOS
    system ENV.cc, "pmdtest.c", "-L#{lib}", "-lpmdmini", "-o", "pmdtest"
    result = `#{testpath}/pmdtest #{testpath}/dd06.m #{testpath}`.chomp
    assert_equal "mus #06", result
  end
end
