class Kjv < Formula
  desc "Read the Word of God from your terminal"
  homepage "https://github.com/ipstone/kjv"
  url "https://github.com/ipstone/kjv/releases/download/v1.0.0/kjv.tar.gz"
  sha256 "d7320a9522ca518074f36d40b4807f8b995d951be0190715a49b79c33ff083e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "b26bfd823ea66d29b9e025d7f1848be88e0498f73a291e081e325f681eed2751" => :catalina
    sha256 "6269707a0803f1a24f491fc04e0927bcaf3b48d006d8e4b908b74b496bad44b2" => :mojave
    sha256 "6f85b86e9321d67734bf4f2d745bb4cac56069d5ff5154f6257982c4da08f50f" => :high_sierra
  end

  depends_on "make" => :build
  depends_on "awk"

  def install
    system "make"
    bin.install "kjv"
  end

  test do
    # Test if kjv will output the help page
    system "kjv", "-h"
    return true
  end
end
