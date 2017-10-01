class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "http://roguecentral.org/doryen/libtcod/"
  url "https://bitbucket.org/libtcod/libtcod/get/1.6.3.tar.bz2"
  sha256 "7bd3142bba45601f1159c6a092cbe9efefa3fe450418c0855d8edc4429d515b7"

  bottle do
    cellar :any
    rebuild 1
    sha256 "904f257a9b9d9512f00de3a07f0eb944019a098188338a2d9a22363cf048f935" => :high_sierra
    sha256 "2841cced50cc98c318751e8cfcae42578eeac4b295b4c6a8f574ca35594c7d6a" => :sierra
    sha256 "8521550c8126b55cd5a77471fa9810e323b6ea3cec8b136fd43723e8901c6457" => :el_capitan
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
