class Pmdmini < Formula
  desc "Plays music in PC-88/98 PMD chiptune format"
  homepage "https://github.com/mistydemeo/pmdmini"
  url "https://github.com/mistydemeo/pmdmini/archive/v1.0.0.tar.gz"
  sha256 "526cb2be1a7e32be9782908cbaeae89b3aca20cad8e42f238916ce9b6d17679c"

  bottle do
    cellar :any
    revision 2
    sha256 "3bdb184f7fc5de0403f2f057764c8ca6a7917967b4970e6fe188f97b5a9fd82f" => :el_capitan
    sha256 "500d3c11ee3ada6481b34e5a7b9d2eb2b9e23da239ca99c7ab0b5da70517bce7" => :yosemite
    sha256 "dba758820ce854aa6780e8e4fe41dc201b618e784bb78f238706ad6dc46da08a" => :mavericks
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
    system ENV.cc, "pmdtest.c", "-lpmdmini", "-o", "pmdtest"
    result = `#{testpath}/pmdtest #{testpath}/dd06.m #{testpath}`.chomp
    assert_equal "mus #06", result
  end
end
