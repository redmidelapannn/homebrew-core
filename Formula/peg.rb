class Peg < Formula
  desc "Program to perform pattern matching on text"
  homepage "http://piumarta.com/software/peg/"
  url "http://piumarta.com/software/peg/peg-0.1.18.tar.gz"
  sha256 "20193bdd673fc7487a38937e297fff08aa73751b633a086ac28c3b34890f9084"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1988648a56576e1fee79ff415591a331c236d20332a3e06ab4f3d53a4763698f" => :mojave
    sha256 "b9f6d4447d854fc8b5742104c783ab8fe18aee8dafd803d2ff3a1c4dc08329cf" => :high_sierra
    sha256 "ef6999cdbf779efa9b4c79515211b61e0a7d2e308be4a91256f0e2c58c628db3" => :sierra
  end

  def install
    system "make", "all"
    bin.install %w[peg leg]
    man1.install gzip("src/peg.1")
  end

  test do
    (testpath/"username.peg").write <<~EOS
      start <- "username"
    EOS

    system "#{bin}/peg", "-o", "username.c", "username.peg"

    assert_match /yymatchString\(yy, "username"\)/, File.read("username.c")
  end
end
