class Hab < Formula
  desc "Automation that Travels with your App"
  homepage "https://www.habitat.sh"
  url "https://api.bintray.com/content/habitat/stable/darwin/x86_64/hab-0.6.0-20160613151520-x86_64-darwin.zip?bt_package=hab-x86_64-darwin"
  sha256 "2251891c376bd3786a2c8242006367a3fd9f896cab850472c73886c6556598d1"

  bottle do
    cellar :any_skip_relocation
    sha256 "24562545a6556928043308c75756b24d4777db5cfcfb17be7910d403dcff2c99" => :el_capitan
    sha256 "585824164f6d86481ea5328eca5d435fd547dcc3ce98972b73ff735f532db747" => :yosemite
    sha256 "183564d50c680fcd3b12dd94c64cabe6c507d015a226081685eb606488a91f19" => :mavericks
  end

  def install
    bin.install "hab"
  end

  test do
    system "#{bin}/hab", "--version"
  end
end
