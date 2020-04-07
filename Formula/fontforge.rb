class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20190801/fontforge-20190801.tar.gz"
  sha256 "d92075ca783c97dc68433b1ed629b9054a4b4c74ac64c54ced7f691540f70852"
  revision 2

  bottle do
    cellar :any
    sha256 "2a06f98a78200dc6e3defaba835800febf43027f8512e78123daf5db994a722a" => :catalina
    sha256 "cdfd59eac86fc105c8cc45dbb9a30cc2d2cfa57b18a536e592e4061a6392af36" => :mojave
    sha256 "f08a1028ba97a5d10818547bd9c7534b238a6c2bf748b0910115903eaf907970" => :high_sierra
  end

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
    ENV["PYTHON_CFLAGS"] = `python3-config --cflags`.chomp
    ENV["PYTHON_LIBS"] = `python3-config --ldflags`.chomp

    system "./configure", "--prefix=#{prefix}",
                          "--enable-python-scripting=3",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-x"
    system "make", "install"

    # The app here is not functional.
    # If you want GUI/App support, check the caveats to see how to get it.
    (pkgshare/"osx/FontForge.app").rmtree

    # Build extra tools
    cd "contrib/fonttools" do
      system "make"
      bin.install Dir["*"].select { |f| File.executable? f }
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
