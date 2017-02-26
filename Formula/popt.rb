class Popt < Formula
  desc "Library like getopt(3) with a number of enhancements"
  homepage "http://rpm5.org"
  url "http://rpm5.org/files/popt/popt-1.16.tar.gz"
  sha256 "e728ed296fe9f069a0e005003c3d6b2dde3d9cad453422a10d6558616d304cc8"

  bottle do
    rebuild 2
    sha256 "1f5b1a66552224f59516178037aae77866ae3028c171ac0b6aa7c28e96015241" => :sierra
    sha256 "ae75138d876679119f03b80eeb672c2f3d9745e06556ec7bdb4f2a409ca80478" => :el_capitan
    sha256 "957e4d9b8b51c974ab557e4e294c58a74a8b0f2d41422287930e7ddbdacef250" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
