class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.38.0/nghttp2-1.38.0.tar.xz"
  sha256 "ef75c761858241c6b4372fa6397aa0481a984b84b7b07c4ec7dc2d7b9eee87f8"
  revision 1

  bottle do
    sha256 "358651c4f71e316d9e62eff5cc0efd7fffc9c2937482687c2f17013c508491f0" => :mojave
    sha256 "94c25c88e7e0d7f98ae869f37407fc11d129cda04012cc3afd9ae209794bfc9f" => :high_sierra
    sha256 "672ff364cbc865923570e0a3bbb82bd3ced1ce4f77997183902424916a301506" => :sierra
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "cunit" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "c-ares"
  depends_on "jansson"
  depends_on "jemalloc"
  depends_on "libev"
  depends_on "libevent"
  depends_on "openssl"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --enable-app
      --disable-python-bindings
      --with-xml-prefix=/usr
    ]

    # requires thread-local storage features only available in 10.11+
    args << "--disable-threads" if MacOS.version < :el_capitan

    system "autoreconf", "-ivf" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
  end
end
