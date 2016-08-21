class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "http://www.libimobiledevice.org"
  url "http://www.libimobiledevice.org/downloads/libplist-1.12.tar.bz2"
  sha256 "0effdedcb3de128c4930d8c03a3854c74c426c16728b8ab5f0a5b6bdc0b644be"

  bottle do
    cellar :any
    rebuild 1
    sha256 "41aa45707115945770d1e9df81858f5674eb828b679629bf86c0fad8fcd0172c" => :el_capitan
    sha256 "790454d6c1bf4910d64fd3b76749e82851f130a616bbb864afe9eee51580749b" => :yosemite
    sha256 "e0f548b1d43e7fe7cbcf0f152dd5fed7952dc9c6869121c79380798fbb9ea393" => :mavericks
  end

  head do
    url "https://git.libimobiledevice.org/libplist.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-python", "Enable Cython Python bindings"
  option "with-python3", "Enable Cython Python3 bindings"

  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on :python => :optional
  depends_on :python3 => :optional

  resource "cython" do
    url "https://pypi.python.org/packages/c6/fe/97319581905de40f1be7015a0ea1bd336a756f6249914b148a17eefa75dc/Cython-0.24.1.tar.gz#md5=890b494a12951f1d6228c416a5789554"
    sha256 "84808fda00508757928e1feadcf41c9f78e9a9b7167b6649ab0933b76f75e7b9"
  end

  if build.with?("python") && build.with?("python3")
    raise "Either python or python3 bindings can be installed at the same time."
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    if build.with? "python3"
      version = Language::Python.major_minor_version "python3"
      resource("cython").stage do
        ENV.prepend_create_path "PYTHONPATH", buildpath/"lib/python#{version}/site-packages"
        system "python3", *Language::Python.setup_install_args(buildpath)
      end
      ENV.prepend_path "PATH", buildpath/"bin"

      args << "PYTHON=python3"
      args << "PYTHON_LDFLAGS=-undefined dynamic_lookup"
    elsif build.with? "python"
      version = Language::Python.major_minor_version "python3"

      resource("cython").stage do
        ENV.prepend_create_path "PYTHONPATH", buildpath/"lib/python#{version}/site-packages"
        system "python", *Language::Python.setup_install_args(buildpath)
      end
      ENV.prepend_path "PATH", buildpath/"bin"
    else
      args << "--without-cython"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install", "PYTHON_LDFLAGS=-undefined dynamic_lookup"

    (include/"plist/cython").install Dir["cython/*"]
  end

  test do
    system "#{bin}/plistutil"
  end
end
