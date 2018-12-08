class Lcs < Formula
  desc "Satirical console-based political role-playing/strategy game"
  homepage "https://sourceforge.net/projects/lcsgame/"
  url "https://svn.code.sf.net/p/lcsgame/code/trunk", :revision => "738"
  version "4.07.4b"
  head "https://svn.code.sf.net/p/lcsgame/code/trunk"

  bottle do
    rebuild 1
    sha256 "20582b81f662d52b6f20dfadc4994c6863734b1a64e1120971b27b3b8f657764" => :high_sierra
    sha256 "a07b00513b5b9bee98437f64102c79a8511352028744175b725e60b33ab0298b" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./bootstrap"
    system "./configure", "LIBS=-liconv", "--prefix=#{prefix}"
    system "make", "install"
  end
end
