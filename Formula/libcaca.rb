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
    sha256 "2231e6e33eb81982850842e9cb73be715236a51f072f3999aa7fcde9d6e0d4c8" => :mojave
    sha256 "ec6eea8578f653352103ca389c55c4dd2a83fb4f6d01eede3f6a5de6dd0a6b30" => :high_sierra
    sha256 "52a62bf7fc51c291cba33462aa964f134353b685af06acac2de374bdf381d847" => :sierra
  end

  head do
    url "https://github.com/cacalabs/libcaca.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  def install
    system "./bootstrap" if build.head?

    # Fix --destdir issue.
    #   ../.auto/py-compile: Missing argument to --destdir.
    inreplace "python/Makefile.in",
              '$(am__py_compile) --destdir "$(DESTDIR)"',
              "$(am__py_compile) --destdir \"$(cacadir)\""

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-doc
      --disable-slang
      --disable-java
      --disable-csharp
      --disable-ruby
      --disable-x11
    ]

    system "./configure", *args
    system "make"
    ENV.deparallelize # Or install can fail making the same folder at the same time
    system "make", "install"
  end

  test do
    system "#{bin}/img2txt", "--version"
  end
end
