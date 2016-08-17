class Sqtop < Formula
  desc "Display information about active connections for a Squid proxy"
  homepage "https://github.com/paleg/sqtop"
  url "https://github.com/paleg/sqtop/archive/v2015-02-08.tar.gz"
  version "2015-02-08"
  sha256 "eae4c8bc16dbfe70c776d990ecf14328acab0ed736f0bf3bd1647a3ac2f5e8bf"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "1359325c6865689527c76af8c69adf6893f4f74efa4f7a7b4712fce065a6e3a4" => :el_capitan
    sha256 "c99808881a09481ec539bc5fb1b7579b2db08ec1db68c5d293192401a5affafe" => :yosemite
    sha256 "709f8ef46fb4d2669501ce131b2d8b528216c002fb1d6a857ffa92a605fbf32b" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqtop --help")
  end
end
