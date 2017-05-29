class Dgen < Formula
  desc "Sega Genesis / Mega Drive emulator"
  homepage "https://dgen.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dgen/dgen/1.33/dgen-sdl-1.33.tar.gz"
  sha256 "99e2c06017c22873c77f88186ebcc09867244eb6e042c763bb094b02b8def61e"
  bottle do
    cellar :any
    rebuild 1
    sha256 "c9721d39dc35f9dd44c7a96700f9c7e3a0fb9ca8b1574f475e6fae1fb143cd5f" => :sierra
    sha256 "d0c8ec1555d7e32b6e9bba46d35460654e48ee0f0ceeb054fb7d8a1d8bb668fa" => :el_capitan
    sha256 "7791d516c807df92b5d6dc95461acdd1f4b5d3a019b11bd3980ce4208060cd4e" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/dgen/dgen.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  option "with-docs", "Build documentation"
  option "with-debugger", "Enable debugger"

  depends_on "sdl"
  depends_on "libarchive"
  depends_on "doxygen" if build.with? "docs"

  def install
    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-sdltest
      --prefix=#{prefix}
    ]
    args << "--enable-debugger" if build.with? "debugger"
    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    If some keyboard inputs do not work, try modifying configuration:
      ~/.dgen/dgenrc
    EOS
  end

  test do
    assert_equal "DGen/SDL version #{version}", shell_output("#{bin}/dgen -v").chomp
  end
end
