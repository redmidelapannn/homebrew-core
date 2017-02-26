class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "https://librsync.sourcefrog.net/"
  url "https://github.com/librsync/librsync/archive/v2.0.0.tar.gz"
  sha256 "b5c4dd114289832039397789e42d4ff0d1108ada89ce74f1999398593fae2169"
  revision 1

  bottle do
    rebuild 1
    sha256 "ef4a184f3751f22cfa85ba5ca4da71def1992cc220f3256e6fb6858dd54f4ff0" => :sierra
    sha256 "962e08f5f018cb7c5fba37d5e9d3d99266a02da0e37aef4ec84bd6247f2e7c33" => :el_capitan
    sha256 "7ab0c09c2bfcb292a7f4f67fa7ec9c44faca0b5b842ffa65549c300ba95197b2" => :yosemite
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
