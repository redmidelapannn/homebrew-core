class Lcs < Formula
  desc "Satirical console-based political role-playing/strategy game"
  homepage "https://sourceforge.net/projects/lcsgame/"
  if MacOS.version >= :sierra
    url "https://svn.code.sf.net/p/lcsgame/code/trunk", :revision => "738"
  else
    url "http://svn.code.sf.net/p/lcsgame/code/trunk", :revision => "738"
  end
  version "4.07.4b"

  head "https://svn.code.sf.net/p/lcsgame/code/trunk"

  bottle do
    rebuild 1
    sha256 "80ef427e19045d9bffb1e71812ce95503cb824f444fc11f7805f14a3d4a436dc" => :sierra
    sha256 "3494a858cfd5138dd3ad286b3207f795f5bd2eb26984655f4d72bcdfff65158c" => :el_capitan
    sha256 "1045e73436ead371ab5f6d9fbc7f34ba6d4d989a9a80b09ef84790afdd1199e1" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./bootstrap"
    system "./configure", "LIBS=-liconv", "--prefix=#{prefix}"
    system "make", "install"
  end
end
