class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.40/vala-0.40.5.tar.xz"
  sha256 "1203a41f5943912450dc55f889bd1018c551a080c893cc6e8303fb47c7fde16d"

  bottle do
    sha256 "7a3218529ac2174d414078f84d6983f2d3e4e34d95cbe987f2196b811e181d2f" => :high_sierra
    sha256 "c267e651f4601af0ef7a14bdcdf294146c9f8ac42e2b35035d67e9ca80cffbbd" => :sierra
    sha256 "0a6318203ef97d00f94c04920ed4c0d85fae0cea1081da176938a1cfa72938c4" => :el_capitan
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
