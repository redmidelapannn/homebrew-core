class Sha2 < Formula
  desc "Implementation of SHA-256, SHA-384, and SHA-512 hash algorithms"
  homepage "https://aarongifford.com/computers/sha.html"
  url "https://aarongifford.com/computers/sha2-1.0.1.tgz"
  sha256 "67bc662955c6ca2fa6a0ce372c4794ec3d0cd2c1e50b124e7a75af7e23dd1d0c"

  bottle do
    cellar :any_skip_relocation
    revision 4
    sha256 "3f2ce9d6dd63c04d573df717948db9981973cab715cac1bf31c6d16b9b49cf65" => :el_capitan
    sha256 "e642fd3a91a3cb21e350125dfb31f39da5cc014554edbb1118bf79fd846527e8" => :yosemite
    sha256 "3902ff23d56418f4a0aa74712667e57130320fdde544e4d6a6b748715f33d22e" => :mavericks
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
