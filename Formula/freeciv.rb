class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.wikia.com/"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%202.6/2.6.0/freeciv-2.6.0.tar.bz2"
  sha256 "7c20399198d6c7d846fed9a69b02e01134ae5340a3ae0f99d1e38063ade6c999"
  revision 1

  bottle do
    sha256 "06e0871a747994f1c5a710de0f1d240c34a9392df6e7fbd74a031474002f6076" => :mojave
    sha256 "34fac1e73bdcaa3a19bd280efed1ab74ba38661d4c8671794dcf9f83505c0eae" => :high_sierra
  end

  head do
    url "https://github.com/freeciv/freeciv.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
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
