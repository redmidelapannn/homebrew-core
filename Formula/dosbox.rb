class Dosbox < Formula
  desc "DOS Emulator"
  homepage "https://www.dosbox.com/"
  url "https://downloads.sourceforge.net/project/dosbox/dosbox/0.74-2/dosbox-0.74-2.tar.gz"
  sha256 "7077303595bedd7cd0bb94227fa9a6b5609e7c90a3e6523af11bc4afcb0a57cf"

  bottle do
    cellar :any
    rebuild 3
    sha256 "6b1b43499ca169fa80dc7f3b4526f2e0cf30f333f34dd61a8da0b2e6da445e20" => :mojave
    sha256 "a71afad3b5852431316806fa36a6fa1d1af1df28037c94272d9468e5064973aa" => :high_sierra
    sha256 "afb170448944a35b709e8871ecb536b71b2add09c3b9c3d753c4089c3c1a8257" => :sierra
  end

  head do
    url "https://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libpng"
  depends_on "sdl"
  depends_on "sdl_net"
  depends_on "sdl_sound"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
      --enable-core-inline
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/dosbox", "-version"
  end
end
