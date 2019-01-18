class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.19.2.tar.gz"
  sha256 "400d47969292291d297873a06fb0535ccce70728117463927ddd9452aa849644"

  bottle do
    cellar :any
    sha256 "162976fa8ed3895c603f29a8b92c893152c1a2ecff98f853aa1f81a5e9db3cf4" => :mojave
    sha256 "da3b23302cf4cc112f21b07dfb9a0baf4ee3929d954f7832dbbeffbe0369bfdb" => :high_sierra
    sha256 "bfb9f8462f2c223e82f47494749570a4df1e33bf7e3d78f12bb27545dd4fd531" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libomp"
  depends_on "little-cms2"

  resource "librawtestfile" do
    url "https://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF"
    sha256 "7886d8b0e1257897faa7404b98fe1086ee2d95606531b6285aed83a0939b768f"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "ac_cv_prog_c_openmp=-Xpreprocessor\\ -fopenmp",
                          "ac_cv_prog_cxx_openmp=-Xpreprocessor\\ -fopenmp",
                          "LDFLAGS=-lomp"
    system "make"
    system "make", "install"
    doc.install Dir["doc/*"]
    prefix.install "samples"
  end

  test do
    resource("librawtestfile").stage do
      filename = "RAW_NIKON_D1.NEF"
      system "#{bin}/raw-identify", "-u", filename
      system "#{bin}/simple_dcraw", "-v", "-T", filename
    end
  end
end
