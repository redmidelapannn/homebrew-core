class Wxmac < Formula
  desc "Cross-platform C++ GUI toolkit (wxWidgets for macOS)"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.0.3.1/wxWidgets-3.0.3.1.tar.bz2"
  sha256 "3164ad6bc5f61c48d2185b39065ddbe44283eb834a5f62beb13f1d0923e366e4"
  revision 1
  head "https://github.com/wxWidgets/wxWidgets.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8c6e4052987406792646a4fd0ba863502a483c4f87d03c63e24245d9b10b95c7" => :high_sierra
    sha256 "003fdfe732650843e45161300f49dbaa71252600434472fa5568eb3946c206d3" => :sierra
    sha256 "6e2a28f22cece3a19bb64590ecefc1ffa95ec655c1cc8cd5a3a19e8fb207b0e1" => :el_capitan
  end

  stable do
    # Fix compilation on High Sierra
    # https://trac.wxwidgets.org/ticket/17929#ticket
    patch do
      url "https://github.com/wxWidgets/wxWidgets/commit/9a610eadcfe.patch?full_index=1"
      sha256 "b445ddf1331b8ec21790b7e3fe3ac6059a2548002e7cbb9bf22b597baf32e3bf"
    end
  end

  devel do
    url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.1/wxWidgets-3.1.1.tar.bz2"
    sha256 "c925dfe17e8f8b09eb7ea9bfdcfcc13696a3e14e92750effd839f5e10726159e"
  end

  option "with-stl", "use standard C++ classes for everything"
  option "with-static", "build static libraries"

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    args = [
      "--prefix=#{prefix}",
      "--enable-clipboard",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--enable-display",
      "--enable-dnd",
      "--enable-graphics_ctx",
      "--enable-std_string",
      "--enable-svg",
      "--enable-unicode",
      "--enable-webkit",
      "--with-expat",
      "--with-libjpeg",
      "--with-libpng",
      "--with-libtiff",
      "--with-opengl",
      "--with-osx_cocoa",
      "--with-zlib",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic",
      # Enabling mediactrl leads to wxconfig trying to pull in a non-existent
      # 64-bit QuickTime framework: https://trac.wxwidgets.org/ticket/17639
      "--disable-mediactrl",
      # Set with-macosx-version-min to avoid configure defaulting to 10.5
      "--with-macosx-version-min=#{MacOS.version}",
    ]

    args << "--enable-stl" if build.with? "stl"
    args << (build.with?("static") ? "--disable-shared" : "--enable-shared")

    system "./configure", *args
    system "make", "install"

    # wx-config should reference the public prefix, not wxmac's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxmac and wxpython headers,
    # which are linked to the same place
    inreplace "#{bin}/wx-config", prefix, HOMEBREW_PREFIX
  end

  test do
    system bin/"wx-config", "--libs"
  end
end
