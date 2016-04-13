class AirportBssid < Formula
  desc "associate to a specific bssid"
  homepage "https://qpshinqp.github.io/airport-bssid/"
  url "https://github.com/qpSHiNqp/airport-bssid/archive/0.1.0.tar.gz"
  sha256 "cf1e81298838aa3d072c280ef5d85dc574958479083f39684647a8c63865a113"
  head "https://github.com/qpSHiNqp/airport-bssid.git"
  bottle do
    cellar :any_skip_relocation
    sha256 "deba384fc397975fa43a98bcfd855e0cc2a69e546789fffc3419f431495cc220" => :el_capitan
    sha256 "385936d7c761e517829caa0fce02e22ef449fa6c963679885f93eda93d776bd7" => :yosemite
    sha256 "cde9188b1a29940f385adc37522af0edc88c21a25d8f31a2148230ce2d9fb47f" => :mavericks
  end

  def install
    xcodebuild
    bin.install "build/Release/airport-bssid"
  end

  test do
    system "airport-bssid"
  end
end
