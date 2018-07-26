class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "http://www.valgrind.org/"

  stable do
    url "https://sourceware.org/pub/valgrind/valgrind-3.13.0.tar.bz2"
    mirror "https://dl.bintray.com/homebrew/mirror/valgrind-3.13.0.tar.bz2"
    sha256 "d76680ef03f00cd5e970bbdcd4e57fb1f6df7d2e2c071635ef2be74790190c3b"

    # valgrind does not yet support High Sierra
    # https://bugs.kde.org/show_bug.cgi?id=383811
    depends_on MaximumMacOSRequirement => :sierra

    # Fix build on 10.12 with Xcode 9
    # Upstream commit from 24 Sep 2017 "Support all Apple clang/LLVM 5.1+"
    # See https://sourceware.org/git/?p=valgrind.git;a=commit;h=27e1503bc7bd767f3a98824176558beaa5a7c1d5
    if DevelopmentTools.clang_build_version >= 900
      patch :p0 do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/b3915f6/valgrind/sierra-xcode9.diff"
        sha256 "156ea88edd2116dd006d6e5550578af3f2a2e3923818a238b9166cd02e327432"
      end
    end
  end

  bottle do
    rebuild 1
    sha256 "822d9c9639f2f86d1176f5b7a9ccd70f5d21c23554eeba9d3881545db8dc5acb" => :sierra
    sha256 "a8d7b1806cbb7dfbdf85711c06f9f55e570587f11d4d17be5bd6dec9f0814119" => :el_capitan
  end

  head do
    url "https://sourceware.org/git/valgrind.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
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

  def caveats; <<~EOS
    For macOS 10.13, install valgrind using the following command:
    $ brew install --HEAD valgrind
  EOS
  end

  test do
    system "#{bin}/valgrind", "ls", "-l"
  end
end
