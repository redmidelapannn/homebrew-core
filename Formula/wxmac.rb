class Wxmac < Formula
  desc "Cross-platform C++ GUI toolkit (wxWidgets for macOS)"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.2/wxWidgets-3.1.2.tar.bz2"
  sha256 "4cb8d23d70f9261debf7d6cfeca667fc0a7d2b6565adb8f1c484f9b674f1f27a"
  revision 1
  head "https://github.com/wxWidgets/wxWidgets.git"

  bottle do
    cellar :any
    sha256 "f03c5eb1b58b8f910411920c1c2b25f485eca0b779c355161eb63cb1177f529f" => :mojave
    sha256 "5a6fe73ed43f6c9589cc3857dc8da2cb5565d0eca8ba9f0a4cc589a2d519181d" => :high_sierra
    sha256 "9a15bdddeedfc08ecae2c1ab5e8d07ea8b16a89d2ec9f7c40d2284935b3bb863" => :sierra
  end

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
      # Set with-macosx-version-min to avoid configure defaulting to 10.5
      "--with-macosx-version-min=#{MacOS.version}",
    ]

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
