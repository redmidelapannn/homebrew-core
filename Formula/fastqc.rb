class Fastqc < Formula
  desc "Quality control tool for high throughput sequence data"
  homepage "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
  url "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip"
  sha256 "dd7a5ad80ceed2588cf6d6ffe35e0f161c0d9977ed08355f5e4d9473282cbd66"

  bottle do
    cellar :any_skip_relocation
    sha256 "74a97385cdbdaf5dc3ef9c053638d18a73bffeb48bea755cc464d686685f19db" => :high_sierra
    sha256 "74a97385cdbdaf5dc3ef9c053638d18a73bffeb48bea755cc464d686685f19db" => :sierra
    sha256 "74a97385cdbdaf5dc3ef9c053638d18a73bffeb48bea755cc464d686685f19db" => :el_capitan
  end

  depends_on :java

  def install
    libexec.install Dir["*"]
    chmod 0755, libexec/"fastqc"
    bin.install_symlink libexec/"fastqc"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      @SRR098281.1 HWUSI-EAS1599_1:2:1:0:318 length=35
      CNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
      +SRR098281.1 HWUSI-EAS1599_1:2:1:0:318 length=35
      #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     EOS
    assert_match "Analysis complete for test.fasta", shell_output("#{bin}/fastqc test.fasta")
  end
end
