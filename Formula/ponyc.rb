class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.2.1.tar.gz"
  sha256 "cb8d6830565ab6b47ecef07dc1243029cef962df7ff926140022abb69d1e554e"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "5d9864fb185c40d8ecbd634198b4378f15e258a5e1d81072f83ac15c440d783c" => :el_capitan
    sha256 "9c42ca38ffa9fe6ca9888229a0a5dece167d4d2db40af6f219ee94606a869afd" => :yosemite
    sha256 "deeb897998f9f52a656f9c544ad0abea2558013b3833fc9a581511008ba4b096" => :mavericks
  end

  depends_on "llvm" => "with-rtti"
  depends_on "libressl"
  depends_on "pcre2"
  needs :cxx11

  def install
    ENV.cxx11
    system "make", "install", "config=release", "destdir=#{prefix}", "verbose=1"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"
  end
end
