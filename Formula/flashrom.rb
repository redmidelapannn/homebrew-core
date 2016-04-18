class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https://flashrom.org/"
  url "https://download.flashrom.org/releases/flashrom-0.9.8.tar.bz2"
  sha256 "13dc7c895e583111ecca370363a3527d237d178a134a94b20db7df177c05f934"

  head "svn://flashrom.org/flashrom/trunk"

  bottle do
    cellar :any
    revision 1
    sha256 "a3e32bd109bf32175548b462c2265b95ec5393600413216cded91b26b1aa0b5f" => :el_capitan
    sha256 "f6d5a6cd741432f29d7e8ab152823c04e36e7d273d8a289b1e4154afcb4fd163" => :yosemite
    sha256 "36e49c7ac048bf70392f83a955f01cace2616882685ac7338a45058e67f759ee" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"
  depends_on "libftdi0"

  def install
    ENV["CONFIG_GFXNVIDIA"] = "0"
    ENV["CONFIG_NIC3COM"] = "0"
    ENV["CONFIG_NICREALTEK"] = "0"
    ENV["CONFIG_NICNATSEMI"] = "0"
    ENV["CONFIG_NICINTEL"] = "0"
    ENV["CONFIG_NICINTEL_SPI"] = "0"
    ENV["CONFIG_NICINTEL_EEPROM"] = "0"
    ENV["CONFIG_OGP_SPI"] = "0"
    ENV["CONFIG_SATAMV"] = "0"
    ENV["CONFIG_SATASII"] = "0"
    ENV["CONFIG_DRKAISER"] = "0"
    ENV["CONFIG_RAYER_SPI"] = "0"
    ENV["CONFIG_INTERNAL"] = "0"
    ENV["CONFIG_IT8212"] = "0"
    ENV["CONFIG_ATAHPT"] = "0"
    ENV["CONFIG_ATAVIA"] = "0"

    system "make", "DESTDIR=#{prefix}", "PREFIX=/", "install"
    mv sbin, bin
  end

  test do
    system "#{bin}/flashrom" " --version"
  end
end
