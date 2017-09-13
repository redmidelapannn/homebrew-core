class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.5.0.tar.gz"
  sha256 "50f7a3e3aec2e08e732a487919262238f8504c3ef927246ec3495617dde81239"
  head "https://github.com/opencollab/arpack-ng.git"

  bottle do
    rebuild 1
    sha256 "b2db871a0a498982c173c11435da75ee5f61ee28f576d15d06b1f077925a8870" => :sierra
    sha256 "f511e62160290086f02562d53568351cf0f88fd7c0392dbfe2b2256b7933ff8c" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on :fortran
  depends_on "veclibfort"
  depends_on :mpi => [:optional, :f77]

  def install
    args = %W[ --disable-dependency-tracking
               --prefix=#{libexec}
               --with-blas=-L#{Formula["veclibfort"].opt_lib}\ -lvecLibFort ]

    args << "F77=#{ENV["MPIF77"]}" << "--enable-mpi" if build.with? "mpi"

    system "./bootstrap"
    system "./configure", *args
    system "make"
    system "make", "install"

    lib.install_symlink Dir["#{libexec}/lib/*"].select { |f| File.file?(f) }
    (lib/"pkgconfig").install_symlink Dir["#{libexec}/lib/pkgconfig/*"]
    pkgshare.install "TESTS/testA.mtx", "TESTS/dnsimp.f",
                     "TESTS/mmio.f", "TESTS/debug.h"

    if build.with? "mpi"
      (libexec/"bin").install (buildpath/"PARPACK/EXAMPLES/MPI").children
    end
  end

  test do
    ENV.fortran
    system ENV.fc, "-o", "test", pkgshare/"dnsimp.f", pkgshare/"mmio.f",
                   "-L#{lib}", "-larpack", "-lvecLibFort"
    cp_r pkgshare/"testA.mtx", testpath
    assert_match "reached", shell_output("./test")

    if build.with? "mpi"
      cp_r (libexec/"bin").children, testpath
      %w[pcndrv1 pdndrv1 pdndrv3 pdsdrv1
         psndrv1 psndrv3 pssdrv1 pzndrv1].each do |slv|
        system "mpirun", "-np", "4", slv
      end
    end
  end
end
