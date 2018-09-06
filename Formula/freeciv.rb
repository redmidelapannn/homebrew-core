class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.wikia.com/"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%202.6/2.6.0/freeciv-2.6.0.tar.bz2"
  sha256 "7c20399198d6c7d846fed9a69b02e01134ae5340a3ae0f99d1e38063ade6c999"

  bottle do
    rebuild 1
    sha256 "7b74b46a057d4678c5253e9f977894fafd57cbe69d0482827e914688edfe9918" => :mojave
    sha256 "79c152defd5ee43c8653c5edd297b36435ad0af80ecfd8816c7f4c32bba9bd0d" => :high_sierra
    sha256 "30e956639ad148343ce0123b140d0351f3a4c3359e06f34cf44eb786be823fc5" => :sierra
    sha256 "0c64533216e0a4d60fb2c45973b17fdac71f525f2e660f30340be3cbe969db4f" => :el_capitan
  end

  head do
    url "https://github.com/freeciv/freeciv.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "icu4c"
  depends_on "pango"
  depends_on "readline"
  depends_on "sdl"
  depends_on "sdl_gfx"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"

  def install
    ENV["ac_cv_lib_lzma_lzma_code"] = "no"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-gtktest
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
      CFLAGS=-I#{Formula["gettext"].include}
      LDFLAGS=-L#{Formula["gettext"].lib}
    ]

    if build.head?
      inreplace "./autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system bin/"freeciv-manual"
    assert_predicate testpath/"classic6.mediawiki", :exist?

    server = fork do
      system bin/"freeciv-server", "-l", testpath/"test.log"
    end
    sleep 5
    Process.kill("TERM", server)
    assert_predicate testpath/"test.log", :exist?
  end
end
