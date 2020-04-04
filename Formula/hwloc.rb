class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v2.2/downloads/hwloc-2.2.0.tar.bz2"
  sha256 "ae70b893df272b84afd7068d351aae5c8c4fd79d40ca783b3e67554b873a2252"

  bottle do
    cellar :any
    sha256 "7f694f56f2085ccb43612143f7a0d3522b611a276060728a8c183df394fa1b48" => :catalina
    sha256 "c2b1d8becc7855a04dd4b25d99678431ee7b19fd33f7e014afd13ec179c23784" => :mojave
    sha256 "2c9aa2af384bfe6d58b994aea0a8515b8ac4198164b1c9f81ea296653073d569" => :high_sierra
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
