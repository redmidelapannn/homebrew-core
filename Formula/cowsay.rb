class Cowsay < Formula
  desc "Configurable talking characters in ASCII art"
  # Historical homepage: https://web.archive.org/web/20120225123719/www.nog.net/~tony/warez/cowsay.shtml
  homepage "https://github.com/tnalpgge/rank-amateur-cowsay"
  url "https://github.com/tnalpgge/rank-amateur-cowsay/archive/cowsay-3.04.tar.gz"
  sha256 "d8b871332cfc1f0b6c16832ecca413ca0ac14d58626491a6733829e3d655878b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a00c6dce04034b9e36cf48b5a3a17a369240c0024b25bf4f519caafcb12cfaa1" => :sierra
    sha256 "a00c6dce04034b9e36cf48b5a3a17a369240c0024b25bf4f519caafcb12cfaa1" => :el_capitan
    sha256 "a00c6dce04034b9e36cf48b5a3a17a369240c0024b25bf4f519caafcb12cfaa1" => :yosemite
  end

  def install
    system "/bin/sh", "install.sh", prefix
    mv prefix/"man", share
  end

  test do
    output = shell_output("#{bin}/cowsay moo")
    assert_match "moo", output  # bubble
    assert_match "^__^", output # cow
  end
end
