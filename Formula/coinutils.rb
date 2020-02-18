class Coinutils < Formula
  desc "COIN-OR utilities"
  homepage "https://github.com/coin-or/CoinUtils"
  url "https://github.com/coin-or/CoinUtils/archive/releases/2.11.4.tar.gz"
  sha256 "d4effff4452e73356eed9f889efd9c44fe9cd68bd37b608a5ebb2c58bd45ef81"
  revision 1

  bottle do
    cellar :any
    sha256 "493ced4b3c04d2ab093698b2ab5ad6cfa6f4c4e47e3d04b0ed1c512e4eb2790a" => :catalina
    sha256 "5fa2ea346fef09039a26fada6c624f8458325879550d8d432c88e23172866c7c" => :mojave
    sha256 "3495cc5f227275c9c6c8086a44a7f19a1f956a600eca1c54807512913b9f2218" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openblas"

  resource "coin-or-tools-data-sample-p0201-mps" do
    url "https://raw.githubusercontent.com/coin-or-tools/Data-Sample/releases/1.2.11/p0201.mps"
    sha256 "8352d7f121289185f443fdc67080fa9de01e5b9bf11b0bf41087fba4277c07a4"
  end

  def install
    args = [
      "--datadir=#{pkgshare}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--includedir=#{include}/coinutils",
      "--prefix=#{prefix}",
      "--with-blas-incdir=#{Formula["openblas"].opt_include}",
      "--with-blas-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-lapack-incdir=#{Formula["openblas"].opt_include}",
      "--with-lapack-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
    ]
    system "./configure", *args
    system "make"

    # Deparallelize due to error 1: "mkdir: #{include}/coinutils/coin: File exists."
    # https://github.com/coin-or/Clp/issues/109
    ENV.deparallelize
    system "make", "install"
  end

  test do
    resource("coin-or-tools-data-sample-p0201-mps").stage testpath
    (testpath/"test.cpp").write <<~EOS
      #include <CoinMpsIO.hpp>
      int main() {
        CoinMpsIO mpsIO;
        return mpsIO.readMps("#{testpath}/p0201.mps");
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{opt_include}/coinutils/coin",
      "-L#{opt_lib}", "-lCoinUtils"
    system "./a.out"
  end
end
