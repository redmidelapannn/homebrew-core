class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v2.0/downloads/hwloc-2.0.1.tar.bz2"
  sha256 "b97575cc26751f252b5c9f5c00be94cab66977da2e127456a5ae2418649ec049"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c8a4b0a994cfbcaa6f901a21f843078f11389a9ba9c406a0a6e5c293e7dbce1e" => :high_sierra
    sha256 "41f4fcccc4a1d02956a9cb4b8e66703ee7690141173dced46dd3c179b6b1769f" => :sierra
    sha256 "a899c5b962bb34a46445ea2250e908c1d8cbf06485f01523906d02f2d97345b7" => :el_capitan
  end

  head do
    url "https://github.com/open-mpi/hwloc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cairo" => :optional
  depends_on :x11 if build.with? "cairo" => ["with-x11"]

  def install
    system "./autogen.sh" if build.head?
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --enable-shared
      --enable-static
      --prefix=#{prefix}
    ]

    if build.with? "cairo" => ["with-x11"]
      args << "--with-x"
    else
      args << "--without-x"
    end

    system "./configure", *args
    system "make", "install"

    pkgshare.install "tests"
  end

  def caveats; <<~EOS
    X11 GUI support for tools like lstopo requires cairo built with X11 support:
      brew install cairo --with-x11
      brew install hwloc --with-cairo
    EOS
  end

  test do
    system ENV.cc, pkgshare/"tests/hwloc/hwloc_groups.c", "-I#{include}",
                   "-L#{lib}", "-lhwloc", "-o", "test"
    system "./test"
  end
end
