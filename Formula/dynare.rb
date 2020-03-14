class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-4.6.1.tar.xz"
  sha256 "ec4e9e5e06519bb5bec60d273d7878725eb2dd64f4443ca2bb14fe0589f76930"

  bottle do
    cellar :any
    sha256 "67ea23545a12628917ba067781e212efd4ad1e9c6b41eeff77a5f0dcbc256eed" => :catalina
    sha256 "2d9eae3afe13a79bd8244fac8598baa99c11064a0662e6ac14bd9157149fefa2" => :mojave
    sha256 "91d58db385d4a0b1d42e5d83a59b04385d6e05d46ba27c8dd9a3f55e69add2a5" => :high_sierra
  end

  head do
    url "https://git.dynare.org/Dynare/dynare.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "flex" => :build
  end

  depends_on "boost" => :build
  depends_on "cweb" => :build
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "gsl"
  depends_on "hdf5"
  depends_on "libmatio"
  depends_on "metis"
  depends_on "octave"
  depends_on "openblas"
  depends_on "suite-sparse"

  resource "slicot" do
    url "https://deb.debian.org/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz"
    sha256 "fa80f7c75dab6bfaca93c3b374c774fd87876f34fba969af9133eeaea5f39a3d"
  end

  def install
    ENV["HOMEBREW_CC"] = "gcc-#{Formula["gcc"].version_suffix}"

    resource("slicot").stage do
      system "make", "lib", "OPTS=-fPIC", "SLICOTLIB=../libslicot_pic.a",
             "FORTRAN=gfortran", "LOADER=gfortran"
      system "make", "clean"
      system "make", "lib", "OPTS=-fPIC -fdefault-integer-8",
             "FORTRAN=gfortran", "LOADER=gfortran",
             "SLICOTLIB=../libslicot64_pic.a"
      (buildpath/"slicot/lib").install "libslicot_pic.a", "libslicot64_pic.a"
    end

    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-matlab",
                          "--with-slicot=#{buildpath}/slicot",
                          "--disable-doc"
    system "make", "install"
  end

  def caveats; <<~EOS
    To get started with Dynare, open Octave and type
      addpath #{opt_lib}/dynare/matlab
  EOS
  end

  test do
    cp lib/"dynare/examples/bkk.mod", testpath
    system Formula["octave"].opt_bin/"octave", "--no-gui", "-H", "--path",
           "#{lib}/dynare/matlab", "--eval", "dynare bkk.mod console"
  end
end
