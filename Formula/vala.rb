class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.40/vala-0.40.9.tar.xz"
  sha256 "c7ff0480779b2d78d6ff78f5fd165b3ba972e4fa9e9da1b411ff4375a78c6a7b"

  bottle do
    sha256 "16f002ea777d9e3cf719a955370779bf812c46d3518e9f3e17f814e3abec5dbb" => :mojave
    sha256 "f7bca8056b6761e2b99515fd83273f10c6a271565d557e537ce4ebc8d837445e" => :high_sierra
    sha256 "3cdc7878f18c8c7b3a4011a2e8bfc0eb0b2f64e220cbbba256e462fbbdf93f48" => :sierra
    sha256 "05fb5ae4efcb45222b181622e6cff6f5907b3e114b1fe881978c755a9098db1c" => :el_capitan
  end

  depends_on "pkg-config"
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
