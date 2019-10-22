class Udns < Formula
  desc "DNS resolver library"
  homepage "https://www.corpit.ru/mjt/udns.html"
  url "https://www.corpit.ru/mjt/udns/udns-0.4.tar.gz"
  sha256 "115108dc791a2f9e99e150012bcb459d9095da2dd7d80699b584ac0ac3768710"

  bottle do
    cellar :any
    rebuild 1
    sha256 "15027e0dcb3b7e373e0641b8e3cb9e2242d70f276589b9c4e8699883aefc77c1" => :catalina
    sha256 "d4b2419830903e596c85b5fc05f93d044f50e4a1262d99e837bf035d59963678" => :mojave
    sha256 "235d3f976ec4e6038917c51648331d7ac4316159c2a9d0b48897f2094c4c63ff" => :high_sierra
  end

  # Build target for dylib. See:
  # https://www.corpit.ru/pipermail/udns/2011q3/000154.html
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/udns/0.4.patch"
    sha256 "4c3de5d04f93e7d7a9777b3baf3905707199fce9c08840712ccb2fb5fd6d90f9"
  end

  def install
    system "./configure"
    system "make"
    system "make", "dylib"

    bin.install "dnsget", "rblcheck"
    doc.install "NOTES", "TODO", "ex-rdns.c"
    include.install "udns.h"
    lib.install "libudns.a", "libudns.0.dylib", "libudns.dylib"
    man1.install "dnsget.1", "rblcheck.1"
    man3.install "udns.3"
  end
end
