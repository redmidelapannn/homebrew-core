class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.io/"
  if MacOS.version >= :sierra
    url "https://svn.code.sf.net/p/fuego/code/trunk", :revision => 1981
  else
    url "http://svn.code.sf.net/p/fuego/code/trunk", :revision => 1981
  end
  version "1.1.SVN"

  head "https://svn.code.sf.net/p/fuego/code/trunk"

  bottle do
    rebuild 1
    sha256 "8ca595174772458153dd264cd70ea0350679ac915b3a3b16ea25430d744fc89e" => :sierra
    sha256 "7026308309d6eea237fce53f01346859f419ddc5d025107ccd0c9042c5f7b5f8" => :el_capitan
    sha256 "715db2dee5a0484e05b0f35e1c2b39001a166a967f14fc7c4185bc7b25b8c193" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install"
  end
end
