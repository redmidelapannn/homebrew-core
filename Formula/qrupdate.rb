class Qrupdate < Formula
  desc "Fast updates of QR and Cholesky decompositions"
  homepage "https://sourceforge.net/projects/qrupdate/"
  url "https://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz"
  sha256 "e2a1c711dc8ebc418e21195833814cb2f84b878b90a2774365f0166402308e08"
  revision 8

  bottle do
    cellar :any
    rebuild 1
    sha256 "f6144b4460c5fe4c47b4fde52f9404305dd6b81b5aaaa5813f9c3580c428a377" => :mojave
    sha256 "03ba07f4bc69272cb07377119563e7cf20e787dfab9520d1153e33417d5102cf" => :high_sierra
    sha256 "2dedcb0b24479232bfa1c6bbc922750999dc7a332ca8c14b70e5b08ff5bfb3ec" => :sierra
  end

  depends_on "gcc" # for gfortran
  depends_on "veclibfort"

  def install
    # Parallel compilation not supported. Reported on 2017-07-21 at
    # https://sourceforge.net/p/qrupdate/discussion/905477/thread/d8f9c7e5/
    ENV.deparallelize

    system "make", "lib", "solib",
                   "BLAS=-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"

    # Confuses "make install" on case-insensitive filesystems
    rm "INSTALL"

    # BSD "install" does not understand GNU -D flag.
    # Create the parent directory ourselves.
    inreplace "src/Makefile", "install -D", "install"
    lib.mkpath

    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "test/tch1dn.f", "test/utils.f"
  end

  test do
    system "gfortran", "-o", "test", pkgshare/"tch1dn.f", pkgshare/"utils.f",
                       "-L#{lib}", "-lqrupdate",
                       "-L#{Formula["veclibfort"].opt_lib}", "-lvecLibFort"
    assert_match "PASSED   4     FAILED   0", shell_output("./test")
  end
end
