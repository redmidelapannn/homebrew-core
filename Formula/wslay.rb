class Wslay < Formula
  desc "C websocket library"
  homepage "https://wslay.sourceforge.io/"
  url "https://github.com/tatsuhiro-t/wslay/releases/download/release-1.1.0/wslay-1.1.0.tar.xz"
  sha256 "0d82d247b847cc08e798ee2f28ee22b331d54e5900b3e1bef184945770185e17"

  bottle do
    cellar :any
    rebuild 1
    sha256 "478fef25b0285ee768d6e9ad97df7e9398ee75d57dc7712219e7e17b7e1f0776" => :mojave
    sha256 "642130b857a8ccc29191706e58d233e6e40d2833f52ba3eecf79d7bb953d462f" => :high_sierra
    sha256 "590dad6d7f8349020a1ab2a1029a910e5538f52480e53551ee1d3ba47fe65264" => :sierra
    sha256 "51aa7c82cb789be4ab253c20672c7fcc2cd4aebd18217f4384348d774e88025e" => :el_capitan
  end

  head do
    url "https://github.com/tatsuhiro-t/wslay.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "cunit" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "check"
    system "make", "install"
  end
end
