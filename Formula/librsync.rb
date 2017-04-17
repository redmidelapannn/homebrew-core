class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "https://librsync.github.io/"
  url "https://github.com/librsync/librsync/archive/v2.0.0.tar.gz"
  sha256 "b5c4dd114289832039397789e42d4ff0d1108ada89ce74f1999398593fae2169"
  revision 1

  bottle do
    rebuild 1
    sha256 "c6e1a1468454b04cf64155058724373a20cd95ec5985b9f46fc700b008daf215" => :sierra
    sha256 "4fa26b6c046a6f1fbfc50decb86a2363bd4d80db2d2446ed1a765b6bb50b5aae" => :el_capitan
    sha256 "44fad62ee296813449f4c1db3221de4ecbc0002940c79b7e5b5e1fcfb5b4b185" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "popt"

  def install
    # https://github.com/librsync/librsync/commit/1765ad0d416
    # https://github.com/librsync/librsync/issues/50
    # Safe to remove when the next stable release is cut.
    inreplace "src/search.c", "if (l == r) {", "if ((l == r) && (l <= bucket->r)) {"

    system "cmake", ".", *std_cmake_args
    system "make", "install"
    man1.install "doc/rdiff.1"
    man3.install "doc/librsync.3"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rdiff -V")
  end
end
