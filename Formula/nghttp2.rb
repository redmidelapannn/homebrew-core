class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.16.1/nghttp2-1.16.1.tar.xz"
  sha256 "226241d4869aec0c755c1650f72839a34ea31ecf31ba75586efa6c2b45a9e2d0"

  bottle do
    sha256 "2bdcf73870d2064a9763b953d0f2839e6d72cb2bd94b5f708b4dace49b0eeb9b" => :sierra
    sha256 "42c7b8a1d6e68617bea7f66306726bbe93fe1d6770f8246ac4846d1bf76f3d12" => :el_capitan
    sha256 "a613becdc833954d927bd2bbbfa8868493b88351d774215fc2a734158c3b123f" => :yosemite
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-examples", "Compile and install example programs"
  option "without-docs", "Don't build man pages"
  option "with-python3", "Build python3 bindings"

  depends_on :python3 => :optional
  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "libxml2" if MacOS.version <= :lion
  depends_on "pkg-config" => :build
  depends_on "cunit" => :build
  depends_on "libev"
  depends_on "openssl"
  depends_on "libevent"
  depends_on "jansson"
  depends_on "boost"
  depends_on "spdylay"
  depends_on "jemalloc" => :recommended

  resource "Cython" do
    url "https://pypi.python.org/packages/c6/fe/97319581905de40f1be7015a0ea1bd336a756f6249914b148a17eefa75dc/Cython-0.24.1.tar.gz"
    sha256 "84808fda00508757928e1feadcf41c9f78e9a9b7167b6649ab0933b76f75e7b9"
  end

  # https://github.com/tatsuhiro-t/nghttp2/issues/125
  # Upstream requested the issue closed and for users to use gcc instead.
  # Given this will actually build with Clang with cxx11, just use that.
  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --enable-app
      --with-boost=#{Formula["boost"].opt_prefix}
      --enable-asio-lib
      --with-spdylay
      --disable-python-bindings
    ]

    args << "--enable-examples" if build.with? "examples"
    args << "--with-xml-prefix=/usr" if MacOS.version > :lion
    args << "--without-jemalloc" if build.without? "jemalloc"

    system "autoreconf", "-ivf" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"

    # Currently this is not installed by the make install stage.
    if build.with? "docs"
      system "make", "html"
      doc.install Dir["doc/manual/html/*"]
    end

    system "make", "install"
    libexec.install "examples" if build.with? "examples"

    if build.with? "python3"
      pyver = Language::Python.major_minor_version "python3"
      ENV["PYTHONPATH"] = cythonpath = buildpath/"cython/lib/python#{pyver}/site-packages"
      cythonpath.mkpath
      ENV.prepend_create_path "PYTHONPATH", lib/"python#{pyver}/site-packages"

      resource("Cython").stage do
        system "python3", *Language::Python.setup_install_args(buildpath/"cython")
      end

      cd "python" do
        system buildpath/"cython/bin/cython", "nghttp2.pyx"
        system "python3", *Language::Python.setup_install_args(prefix)
      end
    end
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
  end
end
