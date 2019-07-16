class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.44/vala-0.44.5.tar.xz"
  sha256 "bb8f8185b805411511786733c4b769c3ee6af8bc879609bffb6c46b8999bc27f"

  bottle do
    rebuild 1
    sha256 "d7b8c1f9de1168a25a3858d1cf9bb1909ccf43a029751456436dc000ee42897f" => :mojave
    sha256 "0c778a4cd8c98fee6b49772200e8eff4ce050867578a2eae5d0227a26134491a" => :high_sierra
    sha256 "f9334b87e337aee98833a243a7c05025d8142db148f702871c1973600baa5cd3" => :sierra
  end

  depends_on "pkg-config" => :build
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
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
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
