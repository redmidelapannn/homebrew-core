class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.32/vala-0.32.0.tar.xz"
  sha256 "07a2aa4ede040789b4b5af817a42249d703bfe8affccb7732ca2b53d00c1fb6e"

  bottle do
    sha256 "334d2fddf48fcaf79217945d693a3ac9adc2caca4a6d28042b1c35955a15f577" => :el_capitan
    sha256 "7e5ade1534d7f66125d28977bbc22e4b2056dac586af3a2f4f278fdf227325fc" => :yosemite
    sha256 "3c11a0e3674fa1432ecf2218627d27bebe606b0eb880f1d1832e61e68a117305" => :mavericks
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
