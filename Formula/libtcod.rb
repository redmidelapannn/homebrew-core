class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.15.1.tar.gz"
  sha256 "2713d8719be53db7a529cbf53064e5bc9f3adf009db339d3a81b50d471bc306f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0628de9ec270505c5827abd8dd641593aaf0b58ee5be1586e4fc2a801d429722" => :catalina
    sha256 "5870a7fc2afa62c6513cc060ae8aecd63627b69a63b0e79e53f167059e9e9bbb" => :mojave
    sha256 "82282e5d8838a8900b5bfb29b60ad1474681c11136496aa2372f74cf03d8bf8e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on :macos # Due to Python 2
  depends_on "sdl2"

  conflicts_with "libzip", "minizip2",
    :because => "libtcod, libzip and minizip2 install a `zip.h` header"

  def install
    cd "buildsys/autotools" do
      system "autoreconf", "-fiv"
      system "./configure"
      system "make"
      lib.install Dir[".libs/*{.a,.dylib}"]
    end
    include.install Dir["include/*"]
    # don't yet know what this is for
    libexec.install "data"
  end
end
