class Libcaca < Formula
  desc "Convert pixel information into colored ASCII art"
  homepage "http://caca.zoy.org/wiki/libcaca"
  url "http://caca.zoy.org/files/libcaca/libcaca-0.99.beta19.tar.gz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/libcaca/libcaca-0.99.beta19.tar.gz"
  mirror "https://fossies.org/linux/privat/libcaca-0.99.beta19.tar.gz"
  version "0.99b19"
  sha256 "128b467c4ed03264c187405172a4e83049342cc8cc2f655f53a2d0ee9d3772f4"

  bottle do
    cellar :any
    rebuild 2
    sha256 "ac58e51cb8f19d0da7299dd915c2aaeecab28b3bd09bae9863e005d4c5cd693a" => :sierra
    sha256 "d77c1e3897fad13cd236c6d8e35f1f51d120dc82e785ae84ed0afea3538c1f27" => :el_capitan
    sha256 "6f8a1f5fa528e4939d3b02b6acd6adb7b7410c25b3bd3d331b78dc90adb99b66" => :yosemite
  end

  head do
    url "https://github.com/cacalabs/libcaca.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "imlib2" => :optional
  depends_on :x11 if build.with? "imlib2"

  def install
    system "./bootstrap" if build.head?

    # Some people can't compile when Java is enabled. See:
    # https://github.com/Homebrew/homebrew/issues/issue/2049

    # Don't build csharp bindings
    # Don't build ruby bindings; fails for adamv w/ Homebrew Ruby 1.9.2

    # Fix --destdir issue.
    #   ../.auto/py-compile: Missing argument to --destdir.
    inreplace "python/Makefile.in", '$(am__py_compile) --destdir "$(DESTDIR)"', "$(am__py_compile) --destdir \"$(cacadir)\""

    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-doc",
            "--disable-slang",
            "--disable-java",
            "--disable-csharp",
            "--disable-ruby"]

    # fix missing x11 header check: https://github.com/Homebrew/homebrew/issues/28291
    args << "--disable-x11" if build.without? "imlib2"

    system "./configure", *args
    system "make"
    ENV.deparallelize # Or install can fail making the same folder at the same time
    system "make", "install"
  end

  test do
    system "#{bin}/img2txt", "--version"
  end
end
