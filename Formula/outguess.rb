class Outguess < Formula
  desc "universal steganographic tool"
  homepage "http://www.rbcafe.com/softwares/outguess/"
  url "https://ftp.mirrorservice.org/sites/ftp.wiretapped.net/pub/security/steganography/outguess/outguess-0.2.tar.gz"
  sha256 "2f951ed7b9b9373fae8fe95616d49c83ae246cf53a2b60a82814228515bfa7d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "815cde36863cbade81ec3d14751b10c72feb75605523dfdf07d6ec07f56fd654" => :el_capitan
    sha256 "8e85798bb1e4c0cd2a33a4adc1e17351af184754a51b5bdcd74489ea59a90d1c" => :yosemite
    sha256 "b3c4b487942bfaeba07583ff073024db94b6e7cd29a4b62359892191101cdb4c" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    bin.install "outguess"
    man1.install "outguess.1"
  end

  test do
    `outguess`
    assert $?.exitstatus == 1
  end
end
