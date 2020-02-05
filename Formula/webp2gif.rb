class Webp2gif < Formula
  desc "Convert animated webp to gif"
  homepage "https://github.com/elsonwx/webp2gif"
  url "https://github.com/elsonwx/webp2gif/archive/v0.1.tar.gz"
  sha256 "3c79adbb5637b4b20d2779a725c8b04941a8943c0b95142da40343ac8f077297"

  bottle do
    cellar :any_skip_relocation
    sha256 "974c98e13650bad0d6e559e6faa153e8ee3cb809ebd9b8caaa0ff9f42d7e1a64" => :catalina
    sha256 "974c98e13650bad0d6e559e6faa153e8ee3cb809ebd9b8caaa0ff9f42d7e1a64" => :mojave
    sha256 "974c98e13650bad0d6e559e6faa153e8ee3cb809ebd9b8caaa0ff9f42d7e1a64" => :high_sierra
  end

  depends_on "imagemagick"
  depends_on "webp"

  def install
    bin.install "webp2gif"
  end

  test do
    system "webp2gif", "-v"
  end
end
