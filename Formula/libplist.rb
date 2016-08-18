class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "http://www.libimobiledevice.org"
  url "http://www.libimobiledevice.org/downloads/libplist-1.12.tar.bz2"
  sha256 "0effdedcb3de128c4930d8c03a3854c74c426c16728b8ab5f0a5b6bdc0b644be"

  bottle do
    cellar :any
    revision 1
    sha256 "74fc03c756d0757561ec5e73a681ecb053ea8fed8982e0c6d9188c090a0ef041" => :el_capitan
    sha256 "6f061edb97776f9265163a208a46f611ec4b5376d6e22ed93f47fccd75044e60" => :yosemite
    sha256 "7fd1dd0e02de237384a1ab3bab728af496d2af38bfb43e6ce7ce016cc2da708f" => :mavericks
  end

  head do
    url "http://git.sukimashita.com/libplist.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-python", "Enable Cython Python bindings"

  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on :python => :optional

  resource "cython" do
    url "https://pypi.python.org/packages/c6/fe/97319581905de40f1be7015a0ea1bd336a756f6249914b148a17eefa75dc/Cython-0.24.1.tar.gz#md5=890b494a12951f1d6228c416a5789554"
    sha256 "84808fda00508757928e1feadcf41c9f78e9a9b7167b6649ab0933b76f75e7b9"
  end

  def install
    ENV.deparallelize
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    if build.with? "python"
      resource("cython").stage do
        ENV.prepend_create_path "PYTHONPATH", buildpath+"lib/python2.7/site-packages"
        system "python", "setup.py", "build", "install", "--prefix=#{buildpath}",
                 "--single-version-externally-managed", "--record=installed.txt"
      end
      ENV.prepend_path "PATH", "#{buildpath}/bin"
    else
      args << "--without-cython"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install", "PYTHON_LDFLAGS=-undefined dynamic_lookup"
  end
end
