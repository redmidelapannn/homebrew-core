class Httpry < Formula
  desc "Packet sniffer for displaying and logging HTTP traffic"
  homepage "https://github.com/jbittel/httpry"
  url "https://github.com/jbittel/httpry/archive/httpry-0.1.8.tar.gz"
  sha256 "b3bcbec3fc6b72342022e940de184729d9cdecb30aa754a2c994073447468cf0"
  head "https://github.com/jbittel/httpry.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "f74570f92950aa7988d2ad738390d2813518c7fe919e5d795976af5bf0980369" => :catalina
    sha256 "913d38d66d4152f13e01d200c06a3bc9a5f23407c7973f48fddbeb1166e40ed9" => :mojave
    sha256 "0d9984e479b581d2e356a4335d75ab7e2ff36b042b61847bc1adcfbbed98dddc" => :high_sierra
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    bin.install "httpry"
    man1.install "httpry.1"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"httpry", "-h"
  end
end
