class Libyubikey < Formula
  desc "C library for manipulating Yubico one-time passwords"
  homepage "https://yubico.github.io/yubico-c/"
  url "https://developers.yubico.com/yubico-c/Releases/libyubikey-1.13.tar.gz"
  sha256 "04edd0eb09cb665a05d808c58e1985f25bb7c5254d2849f36a0658ffc51c3401"

  bottle do
    cellar :any
    rebuild 1
    sha256 "024d5469f761e4a4ff0e628ab586795e98b467eba09b3fe9170d67ddbcffff1b" => :sierra
    sha256 "d38b512a6d27983e5c0e66a5ba96fb064ef0de4f4fca102471cc3bedec9e0779" => :el_capitan
    sha256 "eaee70867cbca844a4a81b324a63034700da84e330ba833ab90c4f950d1ada13" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
