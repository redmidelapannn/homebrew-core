class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.9.0/ncbi-blast-2.9.0+-src.tar.gz"
  version "2.9.0"
  sha256 "a390cc2d7a09422759fc178db84de9def822cbe485916bbb2ec0d215dacdc257"

  bottle do
    rebuild 1
    sha256 "f57c25bbdebe1529e382ea4f9987915c825eaa05c9de1c10f5a0f443b1b96e47" => :catalina
    sha256 "3a58a181da2027931c4e50af54aba6465c2d552b5084fe0131c947487696fe98" => :mojave
    sha256 "889f83926d7ad34456cf167eccdd24abc170d6433152da2c4d444df3808164c1" => :high_sierra
  end

  depends_on "lmdb"

  conflicts_with "proj", :because => "both install a `libproj.a` library"

  def install
    cd "c++" do
      # Use ./configure --without-boost to fix
      # error: allocating an object of abstract class type 'ncbi::CNcbiBoostLogger'
      # Boost is used only for unit tests.
      # See https://github.com/Homebrew/homebrew-science/pull/3537#issuecomment-220136266
      system "./configure", "--prefix=#{prefix}",
                            "--without-debug",
                            "--without-boost"

      # Fix the error: install: ReleaseMT/lib/*.*: No such file or directory
      system "make"

      system "make", "install"
    end
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    output = shell_output("#{bin}/blastn -query test.fasta -subject test.fasta")
    assert_match "Identities = 70/70", output
  end
end
