class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "http://www.valgrind.org/"
  url "ftp://sourceware.org/pub/valgrind/valgrind-3.13.0.tar.bz2"
  mirror "https://dl.bintray.com/homebrew/mirror/valgrind-3.13.0.tar.bz2"
  sha256 "d76680ef03f00cd5e970bbdcd4e57fb1f6df7d2e2c071635ef2be74790190c3b"

  bottle do
    rebuild 1
    sha256 "4817a9bb05e378b321e2d7f9d5824daee1ce4f3a128b0cc8ba6e97af46d817d5" => :sierra
    sha256 "c1c663cdabf0e0027324ce9fee3b726f4a71688e46dd88b2977410e9ef88ca3e" => :el_capitan
    sha256 "1faaa155b6ed03aa7ac535fe0b30420a06333e9cb968c3be02783fe2b6275e79" => :yosemite
  end

  head do
    url "svn://svn.valgrind.org/valgrind/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Fix crash at huge file limit on macOS: https://bugs.kde.org/show_bug.cgi?id=381815
  patch :p0 do
    url "https://bugs.kde.org/attachment.cgi?id=106527"
    sha256 "0c3948225ce8ad4762b0334c1dfea9ce0c8680bf1273ef24fd2c3209288dac68"
  end

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
