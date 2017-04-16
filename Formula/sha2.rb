class Sha2 < Formula
  desc "Implementation of SHA-256, SHA-384, and SHA-512 hash algorithms"
  homepage "https://www.aarongifford.com/computers/sha.html"
  url "https://www.aarongifford.com/computers/sha2-1.0.1.tgz"
  sha256 "67bc662955c6ca2fa6a0ce372c4794ec3d0cd2c1e50b124e7a75af7e23dd1d0c"

  bottle do
    cellar :any_skip_relocation
    rebuild 4
    sha256 "00a532eee2c226e06abaaa6fa7929185754ab9dbbc859a9c1e603c708c5bade8" => :sierra
    sha256 "7bc8a4d06b0d326ec72e9454e755f5af71815332fe2352853d35d9c4470d6fc6" => :el_capitan
    sha256 "938172607cfde27a743accd9f5f5217b70a4ec9c44ad2225c878265217b5c61f" => :yosemite
  end

  option "without-test", "Skip compile-time tests"

  deprecated_option "without-check" => "without-test"

  def install
    system ENV.cc, "-o", "sha2", "sha2prog.c", "sha2.c"
    system "perl", "sha2test.pl" if build.with? "test"
    bin.install "sha2"
  end

  test do
    (testpath/"checkme.txt").write "homebrew"
    output = "12c87370d1b5472793e67682596b60efe2c6038d63d04134a1a88544509737b4"
    assert_match output, pipe_output("#{bin}/sha2 -q -256 #{testpath}/checkme.txt")
  end
end
