class Prodigal < Formula
  desc "Microbial gene prediction"
  homepage "https://github.com/hyattpd/Prodigal"
  url "https://github.com/hyattpd/Prodigal/archive/v2.6.3.tar.gz"
  sha256 "89094ad4bff5a8a8732d899f31cec350f5a4c27bcbdd12663f87c9d1f0ec599f"
  revision 1
  head "https://github.com/hyattpd/Prodigal.git", :branch => "GoogleImport"

  bottle do
    cellar :any_skip_relocation
    sha256 "c125467c009996a44274007a6adc98915588d62bb8e848b0faf745a358347e48" => :mojave
    sha256 "7e2d7ff155c72df1f9eaf53f13c9b6d30af2c2d002207b8c5fa333a6660a8d41" => :high_sierra
    sha256 "72a0eeda14f651bdc4226612f1904dd0ff4627cbf238b9033a0dd1a6b889a0c9" => :sierra
  end

  # Prodigal will have incorrect output if compiled with certain compilers.
  # This will be fixed in the next release. Also see:
  # https://github.com/hyattpd/Prodigal/issues/34
  # https://github.com/hyattpd/Prodigal/issues/41
  patch do
    url "https://patch-diff.githubusercontent.com/raw/hyattpd/Prodigal/pull/35.patch?full_index=1"
    sha256 "fd292c0a98412a7f2ed06d86e0e3f96a9ad698f6772990321ad56985323b99a6"
  end
  def install
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    fasta = <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    assert_match "CDS", pipe_output("#{bin}/prodigal -q -p meta", fasta, 0)
  end
end
