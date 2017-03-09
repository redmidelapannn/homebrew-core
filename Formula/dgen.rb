class Dgen < Formula
  desc "Sega Genesis / Mega Drive emulator"
  homepage "https://dgen.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dgen/dgen/1.33/dgen-sdl-1.33.tar.gz"
  sha256 "99e2c06017c22873c77f88186ebcc09867244eb6e042c763bb094b02b8def61e"
  bottle do
    cellar :any
    rebuild 1
    sha256 "3eaba37e2c5f36f841301b51fb5860040c0e2107d5d332ebcf0d0475c4521120" => :sierra
    sha256 "2efd14a3df40906425614131b3e6e0301be02bd3ec45a60123677e43227070cb" => :el_capitan
    sha256 "4ba0c0a55568e86d6fae9f9a21b8fa4205029a3f512383a1018df72a4d07908a" => :yosemite
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
    if build.with? "debugger"
      args << "--enable-debugger"
    end
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
