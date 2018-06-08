class Wslay < Formula
  desc "C websocket library"
  homepage "https://wslay.sourceforge.io/"
  url "https://github.com/tatsuhiro-t/wslay/releases/download/release-1.1.0/wslay-1.1.0.tar.xz"
  sha256 "0d82d247b847cc08e798ee2f28ee22b331d54e5900b3e1bef184945770185e17"

  bottle do
    cellar :any
    rebuild 1
    sha256 "abef717359465afcfdd3004e0b9ba01d727e3980bc1326b0e00ddcb2a779bc82" => :high_sierra
    sha256 "9a442f80a67b037402618b0a76874c3db4d93213081f96f3c3f0b22d79068556" => :sierra
    sha256 "30939fd620cff4702d15d61a75774b71e1b226fb7b2b3fab8a3acdf96bdd9b7d" => :el_capitan
    sha256 "294d4646dcf7d352368de8b422a5354e72b3027a8678e993d68ea8d55646388e" => :yosemite
    sha256 "410634e15d5ce6f680ccd5d96b97fc2226aad9530aebe42690d3ceb4d7011e69" => :mavericks
  end

  head do
    url "https://github.com/tatsuhiro-t/wslay.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "without-docs", "Don't generate or install documentation"

  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "cunit" => :build
  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--disable-silent-rules"
    system "make", "check"
    system "make", "install"
  end
end
