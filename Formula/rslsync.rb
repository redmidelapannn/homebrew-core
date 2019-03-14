class Rslsync < Formula
  desc "It is a proprietary file sharing system for the BitTorrent protocol"
  homepage "https://www.resilio.com/"
  url "https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz"
  version "2.6.3"
  sha256 "9f6adeaea9a6bdbdf232bc585929816aeeeb3bd654252cabd99f1edb753b9384"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9bafac8c8e8b5e4aaf6839957a24e75a36cb0ac6a611e39e196ae527b390c9d" => :mojave
    sha256 "b877fa66647247908437d8913ef5fbcd73a63a508120c3defb6cb4501d3b4d3a" => :high_sierra
    sha256 "a1d240bbb355844531bf4f724dc055028481f2e42e70c0e938f0549ec2414c88" => :sierra
  end

  def install
    bin.install "rslsync"
  end

  test do
    system "#{bin}/rslsync"
  end
end
