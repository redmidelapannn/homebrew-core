class Gitslave < Formula
  desc "Create group of related repos with one as superproject"
  homepage "https://gitslave.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gitslave/gitslave-2.0.2.tar.gz"
  sha256 "8aa3dcb1b50418cc9cee9bee86bb4b279c1c5a34b7adc846697205057d4826f0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ade914e51a6bbb48670f988c577f255301c771fd9e33c8b700aa828a47322eb4" => :high_sierra
    sha256 "7fc6e45d6b9f8913b427f01c58c087b68c71ef1fe99b380ebe241ff71618d0a3" => :sierra
    sha256 "190f3f073de717beaeecf823ed78ac6ac31d07eb1f4a1ed19576e5ac3f07bac9" => :el_capitan
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/gits --version")
    assert_match "gits version #{version}", output
  end
end
