class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v2.0/downloads/hwloc-2.0.3.tar.bz2"
  sha256 "e393aaf39e576b329a2bff3096d9618d4e39f416874390b58e6573349554c725"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c966f0ec798a01a4ab2ec20659fbc5d5b5ece17139bc3f179bf9651a17cda2d7" => :mojave
    sha256 "7f76661d0cc0285e632a8bcb87d18fb6a5d70d08c96e1e3f6a0cc98d0a819040" => :high_sierra
    sha256 "50690416a315c78a8eac01bb949819e19a628b3569f941eb70881612b087a11d" => :sierra
  end

  head do
    url "https://github.com/open-mpi/hwloc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

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
