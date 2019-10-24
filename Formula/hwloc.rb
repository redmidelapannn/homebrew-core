class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v2.1/downloads/hwloc-2.1.0.tar.bz2"
  sha256 "19429752f772cf68321196970ffb10dafd7e02ab38d2b3382b157c78efd10862"

  bottle do
    cellar :any
    rebuild 1
    sha256 "09fa5ed078400ea2e3032a84fe255ddd70a9e711dd47c1d4cc97491830044dbf" => :catalina
    sha256 "e4baaf938c6ce62255a1aeb3cf297f896363276573cbf45ca62ed54c0a996358" => :mojave
    sha256 "7ffe509dc4c91057385cb5933cda51dcddf0da2906cf5a8897d8bb7856a8c762" => :high_sierra
  end

  head do
    url "https://github.com/open-mpi/hwloc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  uses_from_macos "libxml2"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make", "install"

    pkgshare.install "tests"
  end

  test do
    system ENV.cc, pkgshare/"tests/hwloc/hwloc_groups.c", "-I#{include}",
                   "-L#{lib}", "-lhwloc", "-o", "test"
    system "./test"
  end
end
