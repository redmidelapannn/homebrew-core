class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.7/bcftools-1.7.tar.bz2"
  sha256 "dd4f63d91b0dffb0f0ce88ac75c2387251930c8063f7799611265083f8d302d1"

  bottle do
    rebuild 1
    sha256 "8873506f5462948db4a8b4cd5044de353463d184cfb3b4a34e6da2458e8fbe05" => :high_sierra
    sha256 "bc671dfe36731117f21c7bbb44dc07bf7475a31674c0cd362ba0f46e765a5b27" => :sierra
    sha256 "c7326a80974982b21736d5ba2c4024982aae6744bf2a7912f78d04161708cc9a" => :el_capitan
  end

  depends_on "gsl"
  depends_on "htslib"
  depends_on "xz"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-htslib=#{Formula["htslib"].opt_prefix}",
                          "--enable-libgsl"
    system "make", "install"
    pkgshare.install "test/query.vcf"
  end

  test do
    output = shell_output("#{bin}/bcftools stats #{pkgshare}/query.vcf")
    assert_match "number of SNPs:\t3", output
    assert_match "fixploidy", shell_output("#{bin}/bcftools plugin -l")
  end
end
