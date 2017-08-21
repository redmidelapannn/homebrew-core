class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "http://www.valgrind.org/"
  url "ftp://sourceware.org/pub/valgrind/valgrind-3.13.0.tar.bz2"
  mirror "https://dl.bintray.com/homebrew/mirror/valgrind-3.13.0.tar.bz2"
  sha256 "d76680ef03f00cd5e970bbdcd4e57fb1f6df7d2e2c071635ef2be74790190c3b"

  bottle do
    rebuild 1
    sha256 "da9025de5d8bb18e9c1fb8805c19f49308dde7aeaa5cb3991997e58dbd8d38e9" => :sierra
    sha256 "5caabed0ca0133a7aad2239d4b9dadf23ef2c3fb68fe797f35842c77e3716087" => :el_capitan
    sha256 "246ebab5e8282cc01a7366a47051fb43f94ccb3ce02a750040a5571f2824dc3c" => :yosemite
  end

  head do
    url "svn://svn.valgrind.org/valgrind/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # valgrind does not yet support High Sierra
  # https://bugs.kde.org/show_bug.cgi?id=383811
  depends_on MaximumMacOSRequirement => :sierra

  # Valgrind needs vcpreload_core-*-darwin.so to have execute permissions.
  # See #2150 for more information.
  skip_clean "lib/valgrind"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    if MacOS.prefer_64_bit?
      args << "--enable-only64bit" << "--build=amd64-darwin"
    else
      args << "--enable-only32bit"
    end

    system "./autogen.sh" if build.head?

    # Look for headers in the SDK on Xcode-only systems: https://bugs.kde.org/show_bug.cgi?id=295084
    unless MacOS::CLT.installed?
      inreplace "coregrind/Makefile.in", %r{(\s)(?=/usr/include/mach/)}, '\1'+MacOS.sdk_path.to_s
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/valgrind", "ls", "-l"
  end
end
