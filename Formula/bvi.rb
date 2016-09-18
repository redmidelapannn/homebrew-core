class Bvi < Formula
  desc "Vi-like binary file (hex) editor"
  homepage "http://bvi.sourceforge.net"
  url "https://downloads.sourceforge.net/bvi/bvi-1.4.0.src.tar.gz"
  sha256 "015a3c2832c7c097d98a5527deef882119546287ba8f2a70c736227d764ef802"

  bottle do
    rebuild 1
    sha256 "a86e9033ac2c1ac37ad4baa331b03c9177fd777ee686420e988029663660a934" => :sierra
    sha256 "95a8269dbed8e02300a3f829cd706ec82c9b2b175b48ad11f02ee79b682766ca" => :el_capitan
    sha256 "ac313516b98700ce8de6cc8ee34452779b6aec576b4a2af01100d0f0919e37be" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/bvi", "-c", "q"
  end
end
