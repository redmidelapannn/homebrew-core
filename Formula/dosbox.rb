class Dosbox < Formula
  desc "DOS Emulator"
  homepage "https://www.dosbox.com/"
  url "https://downloads.sourceforge.net/project/dosbox/dosbox/0.74/dosbox-0.74.tar.gz"
  sha256 "13f74916e2d4002bad1978e55727f302ff6df3d9be2f9b0e271501bd0a938e05"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "76542f9f6c2114fd89abf0140625b926d144ac34121395d3fb4c1a3e943d5896" => :sierra
    sha256 "ae056f7afdc811f2a5dac1cdf377f7c01dc73f7ea09040bf34ba16cb79c1eb89" => :el_capitan
    sha256 "7983f970e788a621176462478deb8c0a55901e5d775511d4f0fd37a0a70d5656" => :yosemite
  end

  head do
    url "https://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-debugger", "Enable internal debugger"

  depends_on "sdl"
  depends_on "sdl_net"
  depends_on "sdl_sound"
  depends_on "libpng"
  depends_on "ncurses" if build.with?("debugger")

  conflicts_with "dosbox-x", :because => "both install `dosbox` binaries"

  # Fix compilation with Xcode 9
  # https://sourceforge.net/p/dosbox/patches/274/
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/9102536006/dosbox/xcode9.patch"
      sha256 "a23a4cf691452e5d13e159063d9cd8b9bd508c4982116b471fd6fa72fc021eba"
    end
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
      --enable-core-inline
    ]
    args << "--enable-debug" if build.with? "debugger"

    if build.head?
      # Prevent unstable build with clang
      # https://sourceforge.net/p/dosbox/code-0/3894/
      ENV.O0
    else
      # Disable dynamic cpu core recompilation that crashes on 64-bit platform
      # https://github.com/Homebrew/homebrew-games/issues/171
      args << "--disable-dynrec"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    DOSBox is not built for optimal performance due to unstability on 64-bit platform.
    EOS
  end

  test do
    system "#{bin}/dosbox", "-version"
  end
end
