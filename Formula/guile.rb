class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftpmirror.gnu.org/guile/guile-2.0.12.tar.xz"
  mirror "https://ftp.gnu.org/gnu/guile/guile-2.0.12.tar.xz"
  sha256 "de8187736f9b260f2fa776ed39b52cb74dd389ccf7039c042f0606270196b7e9"
  revision 1

  bottle do
    rebuild 1
    sha256 "77c4293a994ba7e27a1ff15cffe38a25ac8d11750e8af484bfcc12ad97665d44" => :sierra
    sha256 "acdc447af4ed2544f7b00ccbc25c52d28a635b740e61b4affb3964177d8f2a9b" => :el_capitan
    sha256 "e033d2a5e97ea6f32aa79b16301c5c1dffd9f56ec5964683b0b3d8a9b607217c" => :yosemite
  end

  devel do
    url "http://git.savannah.gnu.org/r/guile.git",
        :tag => "v2.1.4",
        :revision => "f9620e01c3d01abc2fd306ba5dc062a2f252eb97"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build

    # Fix "error: address argument to atomic operation must be a pointer to
    # _Atomic type ('gl_uint32_t *' (aka 'unsigned int *') invalid)"
    patch do
      url "https://raw.githubusercontent.com/ilovezfs/formula-patches/d2798a4/guile/guile-atomic-type.patch"
      sha256 "6cec784aa446e4485c79d75ed71c59d04d622293c858cd3d5d5edfe4b5e001ac"
    end
  end

  head do
    url "http://git.sv.gnu.org/r/guile.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkg-config" => :run # guile-config is a wrapper around pkg-config.
  depends_on "libtool" => :run
  depends_on "libffi"
  depends_on "libunistring"
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "readline"

  fails_with :llvm do
    build 2336
    cause "Segfaults during compilation"
  end

  fails_with :clang do
    build 211
    cause "Segfaults during compilation"
  end

  # https://debbugs.gnu.org/cgi/bugreport.cgi?bug=23870
  # https://github.com/Homebrew/homebrew-core/issues/1957#issuecomment-229347476
  if MacOS.version >= :sierra
    patch do
      url "https://gist.githubusercontent.com/rahulg/baa500e84136f0965e9ade2fb36b90ba/raw/4f1081838972ac9621fc68bb571daaf99fc0c045/libguile-stime-sierra.patch"
      sha256 "ff38aa01fe2447bc74ccb6297d2832d0a224ceeb8f00e3a1ca68446d6b1d0f6e"
    end
  end

  def install
    system "./autogen.sh" unless build.stable?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libreadline-prefix=#{Formula["readline"].opt_prefix}",
                          "--with-libgmp-prefix=#{Formula["gmp"].opt_prefix}"
    system "make", "install"

    # A really messed up workaround required on OS X --mkhl
    Pathname.glob("#{lib}/*.dylib") do |dylib|
      lib.install_symlink dylib.basename => "#{dylib.basename(".dylib")}.so"
    end

    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.scm"]
  end

  test do
    hello = testpath/"hello.scm"
    hello.write <<-EOS.undent
    (display "Hello World")
    (newline)
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"

    system bin/"guile", hello
  end
end
