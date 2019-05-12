class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://bitbucket.org/libtcod/libtcod/get/1.8.2.tar.bz2"
  sha256 "a33aa463e78b6df327d2aceae875edad8dba7a9e5ea0f1299c486b99f4bed31c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "37f37880a1a36e5fdd3d4507c31bfec16b3339d13c171a67153dbadd18ec07c5" => :mojave
    sha256 "1f8bcbdad7813c8bad0947ed44661e507330506bb990dc98949c063596ed7644" => :high_sierra
    sha256 "fe0c39548fd6cbe33bfb2744b846746bb8bee7cfc8367c93823772e75f6a9160" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  conflicts_with "libzip", :because => "both install `zip.h` header"

  def install
    cd "build/autotools" do
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
