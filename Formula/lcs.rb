class Lcs < Formula
  desc "Satirical console-based political role-playing/strategy game"
  homepage "https://sourceforge.net/projects/lcsgame/"
  url "https://svn.code.sf.net/p/lcsgame/code/trunk", :revision => "738"
  version "4.07.4b"
  head "https://svn.code.sf.net/p/lcsgame/code/trunk"

  bottle do
    rebuild 1
    sha256 "236e7e3ba873ff482237d44c5374e6b54944dabc6c7dbb01636752028cfffb11" => :mojave
    sha256 "85ec9cecc3f1845b282c187fe37aca854b72630b64114923154063f175d93156" => :high_sierra
    sha256 "2f3318d43e35f59552b40a16dcd77d24a491533918457024d272ec8ed6c2abd1" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./bootstrap"
    system "./configure", "LIBS=-liconv", "--prefix=#{prefix}"
    system "make", "install"
  end
end
