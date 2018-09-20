class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.3.4.2.tar.gz"
  sha256 "2b68b0382ee83b203242dbe63eef20bd1b1a943f6eacbd6108883a01dc7dd148"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cd4d33c35384ea49731509d02b157c3df9857d6c1bf94bd2ad98da7378988b7d" => :mojave
    sha256 "94760bc89fb01cf5b008964380f537ea9e7471d3d9e1439d8e97f12afdc1a258" => :high_sierra
    sha256 "dc1e929947ada89a94eaffe6d1bb9e4b704298860b97969d00192de1710ced49" => :sierra
    sha256 "af605eb55304b8368b345d0c46fc3173a465e9f5722ca05a0ac3e4c0391ee9ed" => :el_capitan
  end

  depends_on "tbb"

  def install
    tbb = Formula["tbb"]
    system "make", "install", "WITH_TBB=1", "prefix=#{prefix}",
           "EXTRA_FLAGS=-L #{tbb.opt_lib}", "INC=-I #{tbb.opt_include}"

    pkgshare.install "example", "scripts"
  end

  test do
    system "#{bin}/bowtie2-build",
           "#{pkgshare}/example/reference/lambda_virus.fa", "lambda_virus"
    assert_predicate testpath/"lambda_virus.1.bt2", :exist?,
                     "Failed to create viral alignment lambda_virus.1.bt2"
  end
end
