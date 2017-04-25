class Dtksettings < Formula
  desc "Deepin Tool Kit Settings Module"
  homepage "https://www.deepin.org"
  url "http://packages.deepin.com/deepin/pool/main/d/dtksettings/dtksettings_0.1.5.orig.tar.xz"
  sha256 "8868bbf45cfc734bcd1c5071029f5ed509378be00133b62908a0f69e0879ecb7"

  bottle do
    cellar :any
    sha256 "291dadc34081d489d81fa5669bfd1d87defee744295d1643a6acc1a4dc0c5655" => :sierra
    sha256 "aa9be2b414887074bcf203241301aaac2e93bec2879441448c14f8c6add839f2" => :el_capitan
    sha256 "76db7f6c035caf6a2c3e074b2167368caac9e003e9f0415e11f919ebc0332bf4" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "qt@5.7"

  def install
    system "qmake", "PREFIX=#{prefix}", "-r", "."
    system "make"
    system "make", "install"
  end

  test do
    system "true"
  end
end
