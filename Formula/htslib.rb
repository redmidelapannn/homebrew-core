class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.7/htslib-1.7.tar.bz2"
  sha256 "be3d4e25c256acdd41bebb8a7ad55e89bb18e2fc7fc336124b1e2c82ae8886c6"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e0c6a598255702e9cadd9e4eb07a04dd707fd9f7192900a7b4e6eecb9e845133" => :high_sierra
    sha256 "4518ea4ed28fa634b8f45910277da13ed339f30f3c44f7654d39ea9e2b0755fa" => :sierra
    sha256 "b19f6e4dc91819896f736fa533beaa9160188f181ca4a941468614634dc3838a" => :el_capitan
  end

  depends_on "xz"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "test"
  end

  test do
    sam = pkgshare/"test/ce#1.sam"
    assert_match "SAM", shell_output("#{bin}/htsfile #{sam}")
    system "#{bin}/bgzip -c #{sam} > sam.gz"
    assert_predicate testpath/"sam.gz", :exist?
    system "#{bin}/tabix", "-p", "sam", "sam.gz"
    assert_predicate testpath/"sam.gz.tbi", :exist?
  end
end
