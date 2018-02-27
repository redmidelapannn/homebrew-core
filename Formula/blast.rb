class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.7.1+-src.tar.gz"
  mirror "http://mirrors.vbi.vt.edu/mirrors/ftp.ncbi.nih.gov/blast/executables/LATEST/ncbi-blast-2.7.1+-src.tar.gz"
  version "2.7.1"
  sha256 "10a78d3007413a6d4c983d2acbf03ef84b622b82bd9a59c6bd9fbdde9d0298ca"

  bottle do
    rebuild 1
    sha256 "08e07e3f7c1014fedf5b90896360859f97bd005f7bb0e3be8b0ecca3a1368e86" => :high_sierra
    sha256 "ede9c485f75bd3d3030f36e0037a275b5f5719a2858180f79bb5cd60b1d513c3" => :sierra
    sha256 "c14e69e7c69bc71ad15ff7ac78bff8648f600e722e85f37bbebe2b31b45b8162" => :el_capitan
  end

  depends_on "lmdb"
  depends_on "python" if MacOS.version <= :snow_leopard

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
