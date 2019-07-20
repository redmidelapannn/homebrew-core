class Peg < Formula
  desc "Program to perform pattern matching on text"
  homepage "https://web.archive.org/web/20190403044205/piumarta.com/software/peg/"
  # Canonical URL not reachable:
  # http://piumarta.com/software/peg/peg-0.1.18.tar.gz
  url "https://deb.debian.org/debian/pool/main/p/peg/peg_0.1.18.orig.tar.gz"
  sha256 "20193bdd673fc7487a38937e297fff08aa73751b633a086ac28c3b34890f9084"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5aa55f5e92e1fb439229e2087f1aaf99bb6d319cf0917f8547459e6b7c2eb207" => :mojave
    sha256 "0ecc89d2930154bc31c84f14cb030a29d11a7488f74b6a40da28f3884bc54371" => :high_sierra
    sha256 "87d8094406c8373d6554d9208d04bddd55afaa7e7af74e3b3f44863e2d9a479c" => :sierra
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
