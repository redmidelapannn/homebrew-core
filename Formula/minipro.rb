class Minipro < Formula
  desc "Open controller for the MiniPRO TL866xx series of chip programmers"
  homepage "https://gitlab.com/DavidGriffith/minipro/"
  url "https://gitlab.com/DavidGriffith/minipro/-/archive/0.4/minipro-0.4.tar.gz"
  sha256 "05e0090eab33a236992f5864f3485924fb5dfad95d8f16916a17296999c094cc"

  bottle do
    cellar :any
    sha256 "693a66674de66bfd33672a60bd439a96a374559b33d77760f072eb93cde01113" => :catalina
    sha256 "ca4b28c7376c6c3c23c38ceeb4d57cf9ca799808307b13cf15022d305c341e04" => :mojave
    sha256 "99d8151d2bc72d0e36804ea85a500f88916493f1a4b53346fa4a190cbdfbc405" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "make"
    bin.install "minipro"
  end

  test do
    output = shell_output("#{bin}/minipro 2>&1")
    assert_match "minipro version", output
  end
end
