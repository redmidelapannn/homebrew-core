class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.31.tar.gz"
  mirror "https://fossies.org/linux/misc/file-5.31.tar.gz"
  sha256 "09c588dac9cff4baa054f51a36141793bcf64926edc909594111ceae60fce4ee"

  bottle do
    rebuild 1
    sha256 "c1de4d589891467c7dd7eba6ce21df9cae3d813748224c0ed14a26558a67154f" => :sierra
    sha256 "1d12504bb58f8d6a4b1a89d820315ff43ea4f14098792e6f79013dfbc7d246a1" => :el_capitan
    sha256 "7fd201a12920a752009cffa84df1d2b1504869ebb6842a1bc9a4db3f8ff4669a" => :yosemite
  end

  depends_on :python => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5",
                          "--enable-static"
    system "make", "install"
    (share+"misc/magic").install Dir["magic/Magdir/*"]

    if build.with? "python"
      cd "python" do
        system "python", *Language::Python.setup_install_args(prefix)
      end
    end

    # Don't dupe this system utility
    rm bin/"file"
    rm man1/"file.1"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <stdio.h>

      #include <magic.h>

      int main(int argc, char **argv) {
          magic_t cookie = magic_open(MAGIC_MIME_TYPE);
          assert(cookie != NULL);
          assert(magic_load(cookie, NULL) == 0);
          // Prints the MIME type of the file referenced by the first argument.
          puts(magic_file(cookie, argv[1]));
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lmagic", "test.c", "-o", "test"
    cp test_fixtures("test.png"), "test.png"
    assert_equal "image/png", shell_output("./test test.png").chomp
  end
end
