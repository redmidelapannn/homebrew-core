class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.7/samtools-1.7.tar.bz2"
  sha256 "e7b09673176aa32937abd80f95f432809e722f141b5342186dfef6a53df64ca1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6bddb32b1713d76fa395b46796056aa213352a4b961e0803c229fbe62827d3ea" => :high_sierra
    sha256 "32934aef949606e6e40de0238b5c980b82661bcbd6074aa4f42fa9faf2be0903" => :sierra
    sha256 "933274d42b9cc46c18b948fb0619452059af7ff3dfa54e489bb5504575d50069" => :el_capitan
  end

  depends_on "htslib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-htslib=#{Formula["htslib"].opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system bin/"samtools", "faidx", "test.fasta"
    assert_equal "U00096.2:1-70\t70\t15\t70\t71\n", (testpath/"test.fasta.fai").read
  end
end
