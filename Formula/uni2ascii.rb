class Uni2ascii < Formula
  desc "Bi-directional conversion between UTF-8 and various ASCII flavors"
  # homepage/url: "the website you are looking for is suspended"
  # Switched to Debian mirrors June 2015.
  homepage "https://billposer.org/Software/uni2ascii.html"
  url "https://deb.debian.org/debian/pool/main/u/uni2ascii/uni2ascii_4.18.orig.tar.gz"
  sha256 "9e24bb6eb2ced0a2945e2dabed5e20c419229a8bf9281c3127fa5993bfa5930e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e2b98a53ed3ec8df7b2f46cb8587a77e135ea44fb8ca43647fe8566db8dd8130" => :mojave
    sha256 "50d395be9cafe5e360ba492e011f5739e47d2a6cb1805800e3572dff341a5c3a" => :high_sierra
    sha256 "bde4da96f6689cce8eacc1656b0f31367a1e8c3d314a45b2bec1038c98944941" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    ENV["MKDIRPROG"]="mkdir -p"
    system "make", "install"
  end

  test do
    # uni2ascii
    assert_equal "0x00E9", pipe_output("#{bin}/uni2ascii -q", "é")

    # ascii2uni
    assert_equal "e\n", pipe_output("#{bin}/ascii2uni -q", "0x65")
  end
end
