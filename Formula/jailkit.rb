class Jailkit < Formula
  desc "Utilities to create limited user accounts in a chroot jail"
  homepage "https://olivier.sessink.nl/jailkit/"
  url "https://olivier.sessink.nl/jailkit/jailkit-2.19.tar.bz2"
  sha256 "bebbf6317a5a15057194dd2cf6201821c48c022dbc64c12756eb13b61eff9bf9"

  bottle do
    rebuild 1
    sha256 "42a01a4049763f141fdcf4b15363c9e6c860b5653712538d88bbdc286795d9b0" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
