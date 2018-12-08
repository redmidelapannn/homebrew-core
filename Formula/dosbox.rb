class Dosbox < Formula
  desc "DOS Emulator"
  homepage "https://www.dosbox.com/"
  url "https://downloads.sourceforge.net/project/dosbox/dosbox/0.74-2/dosbox-0.74-2.tar.gz"
  sha256 "7077303595bedd7cd0bb94227fa9a6b5609e7c90a3e6523af11bc4afcb0a57cf"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5bf0b1f6d9aa6483618169ebe986bceb36ee0576a9140c1c24f63730caa00011" => :mojave
    sha256 "0d187cfe44d724063c5c43357020c18cd876c58e0505fb4e6097d3da9684a7ee" => :high_sierra
    sha256 "73e5746d245688d2dba8369980435dc7f95e4e7b74bd0005786c94b86648bbbb" => :sierra
  end

  head do
    url "https://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-debugger", "Enable internal debugger"

  depends_on "libpng"
  depends_on "ncurses" if build.with?("debugger")
  depends_on "sdl"
  depends_on "sdl_net"
  depends_on "sdl_sound"

  conflicts_with "dosbox-x", :because => "both install `dosbox` binaries"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
      --enable-core-inline
    ]
    args << "--enable-debug" if build.with? "debugger"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/dosbox", "-version"
  end
end
