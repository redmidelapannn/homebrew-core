class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.40/vala-0.40.0.tar.xz"
  sha256 "15888fcb5831917cd67367996407b28fdfc6cd719a30e6a8de38a952a8a48e71"

  bottle do
    sha256 "10c3d494ac28f302f65c65f4b44b86662485d5678bf7b041db81f5e683e707d9" => :high_sierra
    sha256 "9b0fc253cefe0abcf9ce86477494c7856afb98639d88e648ea89c965118b7792" => :sierra
    sha256 "394f6e36e1f3407debe65b555847ebe6fbe0c29dfb4555ec88b3286663594e7c" => :el_capitan
  end

  depends_on "pkg-config" => :run
  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"

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
    path.write <<~EOS
      void main () {
        print ("#{test_string}");
      }
    EOS
    valac_args = [
      # Build with debugging symbols.
      "-g",
      # Use Homebrew's default C compiler.
      "--cc=#{ENV.cc}",
      # Save generated C source code.
      "--save-temps",
      # Vala source code path.
      path.to_s,
    ]
    system "#{bin}/valac", *valac_args
    assert_predicate testpath/"hello.c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
