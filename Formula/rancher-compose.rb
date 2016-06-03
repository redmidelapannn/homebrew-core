class RancherCompose < Formula
  desc "Docker compose compatible client to deploy to Rancher"
  homepage "http://docs.rancher.com/rancher/latest/en/rancher-compose/"
  url "https://github.com/rancher/rancher-compose/releases/download/v0.8.2/rancher-compose-darwin-386-v0.8.2.tar.gz"
  sha256 "116af6f0228da287959e3db76f6de56c819add159e8f1948b66c4b27b76ad889"

  bottle do
    cellar :any_skip_relocation
    sha256 "6420500411dfc7c8c9333a6970aa32898c1a9373bc92f975eb45293d38234ed3" => :el_capitan
    sha256 "fbb82964868a46ead5bd689adefbf910122e8460b720d130b1369eb45cb27c8a" => :yosemite
    sha256 "1c10891709ddef20fde29e51d4d474c6591d637d0aa3cd794d1a6205cc53ad3b" => :mavericks
  end

  def install
    bin.install "rancher-compose"
  end

  test do
    assert_match /#{version}/, shell_output(bin/"rancher-compose --version")
  end
end
