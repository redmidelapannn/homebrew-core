class Pmdmini < Formula
  desc "Plays music in PC-88/98 PMD chiptune format"
  homepage "https://github.com/mistydemeo/pmdmini"
  url "https://github.com/mistydemeo/pmdmini/archive/v1.0.1.tar.gz"
  sha256 "5c866121d58fbea55d9ffc28ec7d48dba916c8e1bed1574453656ef92ee5cea9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "aceaee918964780ee6a7fefd7cb995b003f566dcfe18c76437f5d75b14d93e79" => :mojave
    sha256 "a01c2c1c1dcfb6d5e1c04a88d92ff39b24d994b393a79b19ec538b257371144b" => :high_sierra
    sha256 "2a56c9afe96358398cfc8cae60d2292f6bdbdb0391a051eb69c8b8bfc8986b48" => :sierra
    sha256 "841b6a8e08a33fcbb5960548535ac7dcb862f39846d0306f155c2cfa678df776" => :el_capitan
  end

  depends_on "sdl"

  resource "test_song" do
    url "https://ftp.modland.com/pub/modules/PMD/Shiori%20Ueno/His%20Name%20Is%20Diamond/dd06.m"
    sha256 "36be8cfbb1d3556554447c0f77a02a319a88d8c7a47f9b7a3578d4a21ac85510"
  end

  def install
    # Specify Homebrew's cc
    inreplace "mak/general.mak", "gcc", ENV.cc
    system "make"

    # Makefile doesn't build a dylib
    system "#{ENV.cc} -dynamiclib -install_name #{lib}/libpmdmini.dylib -o libpmdmini.dylib -undefined dynamic_lookup obj/*.o"

    bin.install "pmdplay"
    lib.install "libpmdmini.a", "libpmdmini.dylib"
    (include+"libpmdmini").install Dir["src/*.h"]
    (include+"libpmdmini/pmdwin").install Dir["src/pmdwin/*.h"]
  end

  test do
    resource("test_song").stage testpath
    (testpath/"pmdtest.c").write <<~EOS
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
