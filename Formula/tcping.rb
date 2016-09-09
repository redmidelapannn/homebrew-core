class Tcping < Formula
  desc "TCP connect to the given IP/port combo"
  homepage "http://linuxco.de/tcping/tcping.html"
  url "https://mirrors.kernel.org/gentoo/distfiles/tcping-1.3.5.tar.gz"
  sha256 "1ad52e904094d12b225ac4a0bc75297555e931c11a1501445faa548ff5ecdbd0"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "21bfa0835942463e1c5690d4df92298b47de9618d0bd2105ec15e1da59c8dd92" => :el_capitan
    sha256 "e5f561e84fc5293545807246e6a96122e57b66f5fce98a854805c049cc47ba6e" => :yosemite
    sha256 "047d2e177ce66651c2aaff4b3bb8a6c4fd6ac124d0199cb46f64cdf64d9674a6" => :mavericks
  end

  def install
    system "make"
    bin.install "tcping"
  end

  test do
    system "#{bin}/tcping", "www.google.com", "80"
  end
end
