class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20200314/fontforge-20200314.tar.xz"
  sha256 "cd190b237353dc3f48ddca7b0b3439da8ec4fcf27911d14cc1ccc76c1a47c861"

  bottle do
    sha256 "315af81bdebdb2419e91b1cb2bcbc934074ad9fced3f8ffac3f64cbd3583bd99" => :catalina
    sha256 "f736de0e7133c22f4cbcf4c9d432b60644d3cff1a366fc0eb6b3de661fc6821a" => :mojave
    sha256 "745fcb441da95df152d902b74b19e1ba0120bc04fbd44ddbda3f16fdd80d7022" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libspiro"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "libuninameslist"
  depends_on "pango"
  depends_on "python"
  depends_on "readline"
  uses_from_macos "libxml2"

  def install
    mkdir "build" do
      system "cmake", "..", "-DENABLE_GUI=OFF",
                            "-DENABLE_FONTFORGE_EXTRAS=ON",
                            *std_cmake_args
      system "make", "install"

      # The "extras" built above don't get installed by default.
      bin.install Dir["bin/*"].select { |f| File.executable? f }
    end
  end

  def caveats
    <<~EOS
      This formula only installs the command line utilities.

      FontForge.app can be downloaded directly from the website:
        https://fontforge.github.io

      Alternatively, install with Homebrew Cask:
        brew cask install fontforge
    EOS
  end

  test do
    system bin/"fontforge", "-version"
    system bin/"fontforge", "-lang=py", "-c", "import fontforge; fontforge.font()"
    xy = Language::Python.major_minor_version "python3"
    ENV.append_path "PYTHONPATH", lib/"python#{xy}/site-packages"
    system "python3", "-c", "import fontforge; fontforge.font()"
  end
end
