class Clens < Formula
  desc "Library to help port code from OpenBSD to other operating systems"
  homepage "https://github.com/conformal/clens"
  url "https://github.com/conformal/clens/archive/CLENS_0_7_0.tar.gz"
  sha256 "0cc18155c2c98077cb90f07f6ad8334314606c4be0b6ffc13d6996171c7dc09d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ff07d7c5e000ddc9a7e8ba92c79d560b1ec0c2a3c7005aa8b496d0d02ee20039" => :sierra
    sha256 "425d53227e759c0ecebe9f9a53f3759bd0cd03a13606c59b19661bce7a81416a" => :el_capitan
    sha256 "111030225c67ddb1b286f9d45b32cdad36474670806c1f1d97bbc95ae3e2b72e" => :yosemite
  end

  patch do
    url "https://github.com/conformal/clens/commit/83648cc9027d9f76a1bc79ddddcbed1349b9d5cd.diff"
    sha256 "a685d970c9bc785dcc892f39803dad2610ce979eb58738da5d45365fd81a14be"
  end

  def install
    ENV.deparallelize
    system "make", "all", "install", "LOCALBASE=#{prefix}"
  end
end
