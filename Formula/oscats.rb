class Oscats < Formula
  desc "Computerized adaptive testing system"
  homepage "https://code.google.com/archive/p/oscats/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/oscats/oscats-0.6.tar.gz"
  sha256 "2f7c88cdab6a2106085f7a3e5b1073c74f7d633728c76bd73efba5dc5657a604"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "b93224a214a8b4fac82acb15233033a6c84adc26c202e7478658f1c8e1785d0a" => :mojave
    sha256 "0940067971eccc572e5ef594dca504d2e8a6134370b92d1fcf02f5520c83c06b" => :high_sierra
    sha256 "d568d4ac3d4d70ed364311ff41f68837bf6e8a266863cadc77a702251a4cfc69" => :sierra
    sha256 "727cfe4c71d3c6d4ce702a27dc5cbc7038a0705a3cef1ff262a875e29ad980e1" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gsl"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
