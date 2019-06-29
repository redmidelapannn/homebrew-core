class Bwa < Formula
  desc "Burrow-Wheeler Aligner for pairwise alignment of DNA"
  homepage "https://github.com/lh3/bwa"
  url "https://github.com/lh3/bwa/releases/download/v0.7.17/bwa-0.7.17.tar.bz2"
  sha256 "de1b4d4e745c0b7fc3e107b5155a51ac063011d33a5d82696331ecf4bed8d0fd"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "da9160eff23936c0f29cfa7180487dc8e01f4c501011b87ccd779895a5a06f8e" => :mojave
    sha256 "f40f0ee0159347971665752ee167021c09461b6217e5a5c5dda868a70b937bb2" => :high_sierra
    sha256 "e39596815845edb5aed08aa297d71ef53b3e27d58c6ad7fbb7de85106faa1878" => :sierra
  end

  uses_from_macos "zlib"

  def install
    system "make"

    # "make install" requested 26 Dec 2017 https://github.com/lh3/bwa/issues/172
    bin.install "bwa"
    man1.install "bwa.1"
  end

  test do
    (testpath/"test.fasta").write ">0\nAGATGTGCTG\n"
    system bin/"bwa", "index", "test.fasta"
    assert_predicate testpath/"test.fasta.bwt", :exist?
    assert_match "AGATGTGCTG", shell_output("#{bin}/bwa mem test.fasta test.fasta")
  end
end
