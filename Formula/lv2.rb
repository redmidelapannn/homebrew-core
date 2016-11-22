class Lv2 < Formula
  desc "Portable plugin standard for audio systems"
  homepage "http://lv2plug.in"
  url "http://lv2plug.in/spec/lv2-1.14.0.tar.bz2"
  sha256 "b8052683894c04efd748c81b95dd065d274d4e856c8b9e58b7c3da3db4e71d32"
  bottle do
    cellar :any
    sha256 "9410ab55c95bbe9577e828fb88d2d7b1c004fa1a53f65bfa9ba5ba5c7aef5222" => :sierra
    sha256 "64b76a65718d9c1be383864398f7aaec72ae723adea16ceec82ffd80b47c2dff" => :el_capitan
    sha256 "cc97683d6a0b04c84d2d8e63c3caf064b188b9ae559a0853d41ad57e3db22378" => :yosemite
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--lv2dir=#{lib}/lv2/"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
  end
end
