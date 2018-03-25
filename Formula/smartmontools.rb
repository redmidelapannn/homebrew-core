class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage "https://www.smartmontools.org/"
  url "https://downloads.sourceforge.net/project/smartmontools/smartmontools/6.6/smartmontools-6.6.tar.gz"
  sha256 "51f43d0fb064fccaf823bbe68cf0d317d0895ff895aa353b3339a3b316a53054"

  bottle do
    rebuild 1
    sha256 "690247f12cf3dbc2c5b0497761cd5bfe6e21598f1d89e6901f0874a401514802" => :high_sierra
    sha256 "9f060a40799b63d4d398b01d632ac3d594742ce297bc265d74a779465c0d6d38" => :sierra
    sha256 "f82bef14d2119b5b53d141c56c4b2055986ae4015b173068a69b397e0194ed9f" => :el_capitan
  end

  def install
    (var/"run").mkpath
    (var/"lib/smartmontools").mkpath

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-savestates",
                          "--with-attributelog"
    system "make", "install"
  end

  test do
    system "#{bin}/smartctl", "--version"
    system "#{bin}/smartd", "--version"
  end
end
