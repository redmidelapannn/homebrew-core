class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.48/vala-0.48.2.tar.xz"
  sha256 "f095b0e624b8f4e5a426028ac255e477fad8c3b4c8cbbdebda8d6cd95bf79477"

  bottle do
    sha256 "d9c5776a698416c4af736ad7e8a7738da813d579827ed8a54d7d631f2299da2f" => :catalina
    sha256 "5925b2cbbb88c5bea9d94f15ceb1c1301de9fb119d4914aaccb9414b046eae42" => :mojave
    sha256 "5b076ef5b3dc3b819ff9d87e1f214786b8c396f9edbf00b414ee18558ce553cd" => :high_sierra
  end

  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

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
