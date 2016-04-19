class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.32/vala-0.32.0.tar.xz"
  sha256 "07a2aa4ede040789b4b5af817a42249d703bfe8affccb7732ca2b53d00c1fb6e"

  bottle do
    sha256 "33600496362c493e97794307bb036f89539899c81274d37e156af1d6d071a5b9" => :el_capitan
    sha256 "e839e6d70c4f37699e387e5b7a313eeaa5657c0014162fefb360fca63396113d" => :yosemite
    sha256 "0b724096fcb4c2f3f6b33819f39cd44215b337ecc52d0a2cd23c3489d492fd07" => :mavericks
  end

  depends_on "pkg-config" => :run
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.vala"
    path.write <<-EOS
      void main () {
        print ("#{test_string}");
      }
    EOS
    valac_args = [ # Build with debugging symbols.
      "-g",
      # Use Homebrew's default C compiler.
      "--cc=#{ENV.cc}",
      # Save generated C source code.
      "--save-temps",
      # Vala source code path.
      path.to_s]
    system "#{bin}/valac", *valac_args
    assert File.exist?(testpath/"hello.c")

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
