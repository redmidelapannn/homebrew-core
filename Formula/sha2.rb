class Sha2 < Formula
  desc "Implementation of SHA-256, SHA-384, and SHA-512 hash algorithms"
  homepage "https://www.aarongifford.com/computers/sha.html"
  url "https://www.aarongifford.com/computers/sha2-1.0.1.tgz"
  sha256 "67bc662955c6ca2fa6a0ce372c4794ec3d0cd2c1e50b124e7a75af7e23dd1d0c"

  bottle do
    cellar :any_skip_relocation
    rebuild 4
    sha256 "5f8c15a0894a01e0bc3fb215cd9131e27ebd6e8d394e24a33d5a33449e7134ac" => :mojave
    sha256 "bcde6347d09fabeea0c4758cb69925812e9133703afabe0759357671e5aa6a11" => :high_sierra
    sha256 "78ffa5b44d996d289a1421e11668279e529b2f77458eead61e5c5453c3a52517" => :sierra
    sha256 "9f88787ab1a8a82543665940fea3c4b3e231a4a4998cc184364d324e0f28e9f5" => :el_capitan
  end

  def install
    system ENV.cc, "-o", "sha2", "sha2prog.c", "sha2.c"
    system "perl", "sha2test.pl"
    bin.install "sha2"
  end

  test do
    (testpath/"checkme.txt").write "homebrew"
    output = "12c87370d1b5472793e67682596b60efe2c6038d63d04134a1a88544509737b4"
    assert_match output, pipe_output("#{bin}/sha2 -q -256 #{testpath}/checkme.txt")
  end
end
