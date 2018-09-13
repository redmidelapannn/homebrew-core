class Blahtexml < Formula
  desc "Converts equations into Math ML"
  homepage "http://gva.noekeon.org/blahtexml/"
  url "http://gva.noekeon.org/blahtexml/blahtexml-0.9-src.tar.gz"
  sha256 "c5145b02bdf03cd95b7b136de63286819e696639824961d7408bec4591bc3737"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "56999a45fa8f4b46e0728f5df7bb6967988f19a61209450b98d78b18cf6d6d44" => :mojave
    sha256 "bca29f2cc7aafc1e7d1dc501ff3894195fd7e00fb3d625d50dcb4827308f5f2f" => :high_sierra
    sha256 "ef0cda96eaa74bdca146fd6f61bbd152507851eddc2deaf7241d13ad2f4c725f" => :sierra
    sha256 "79a41c85728ecf6ec50d11ca250b317066c95dd7d4fc490d15099334b5750072" => :el_capitan
  end

  depends_on "xerces-c"
  needs :cxx11

  # Add missing unistd.h includes, taken from MacPorts
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0632225f/blahtexml/patch-mainPng.cpp.diff"
    sha256 "7d4bce5630881099b71beedbbc09b64c61849513b4ac00197b349aab2eba1687"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0632225f/blahtexml/patch-main.cpp.diff"
    sha256 "d696d10931f2c2ded1cef50842b78887dba36679fbb2e0abc373e7b6405b8468"
  end

  def install
    ENV.cxx11

    system "make", "blahtex-mac"
    bin.install "blahtex"
    system "make", "blahtexml-mac"
    bin.install "blahtexml"
  end
end
