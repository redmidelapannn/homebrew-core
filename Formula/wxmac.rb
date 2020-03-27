class Wxmac < Formula
  desc "Cross-platform C++ GUI toolkit (wxWidgets for macOS)"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.3/wxWidgets-3.1.3.tar.bz2"
  sha256 "fffc1d34dac54ff7008df327907984b156c50cff5a2f36ee3da6052744ab554a"
  head "https://github.com/wxWidgets/wxWidgets.git"

  bottle do
    cellar :any
    sha256 "a35c1fca577e9a9053a42268b1fcc5ab074596bca3f60ef98c435afc78e7626d" => :catalina
    sha256 "e8d415d07f6e62f666c45704ed46877bad7f5780d56755792a3ba1a985b0da0e" => :mojave
    sha256 "6b38be99768684560ff32f6b70b16beedca3e7889b8c66c057a1936f0c51e544" => :high_sierra
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
