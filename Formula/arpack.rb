class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.7.0.tar.gz"
  sha256 "972e3fc3cd0b9d6b5a737c9bf6fd07515c0d6549319d4ffb06970e64fa3cc2d6"
  head "https://github.com/opencollab/arpack-ng.git"

  bottle do
    cellar :any
    sha256 "32bbd78df52153cad12295c03e43153b28c57386ac6d9cffbd8bf37acb6dd8e1" => :mojave
    sha256 "00fd1bbbbeb058dd27c1713054b2b8ef66741a3200eb16f07bf9a59db477239d" => :high_sierra
    sha256 "a3f9f41738c44a5432ed7d7b26eb9801fad5b90188f423a1550e24cc4763cac8" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "veclibfort"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --with-blas=-L#{Formula["veclibfort"].opt_lib}\ -lvecLibFort
      F77=mpif77
      --enable-mpi
    ]

    system "./bootstrap"
    system "./configure", *args
    system "make"
    system "make", "install"

    lib.install_symlink Dir["#{libexec}/lib/*"].select { |f| File.file?(f) }
    (lib/"pkgconfig").install_symlink Dir["#{libexec}/lib/pkgconfig/*"]
    pkgshare.install "TESTS/testA.mtx", "TESTS/dnsimp.f",
                     "TESTS/mmio.f", "TESTS/debug.h"

    (libexec/"bin").install (buildpath/"PARPACK/EXAMPLES/MPI").children
  end

  test do
    system "gfortran", "-o", "test", pkgshare/"dnsimp.f", pkgshare/"mmio.f",
                       "-L#{lib}", "-larpack",
                       "-L#{Formula["veclibfort"].opt_lib}", "-lvecLibFort"
    cp_r pkgshare/"testA.mtx", testpath
    assert_match "reached", shell_output("./test")

    cp_r (libexec/"bin").children, testpath
    %w[pcndrv1 pdndrv1 pdndrv3 pdsdrv1
       psndrv1 psndrv3 pssdrv1 pzndrv1].each do |slv|
      system "mpirun", "-np", "4", slv
    end
  end
end
