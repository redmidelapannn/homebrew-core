class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20190413/fontforge-20190413.tar.gz"
  sha256 "6762a045aba3d6ff1a7b856ae2e1e900a08a8925ccac5ebf24de91692b206617"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "5e319ddc59a7f353e450d3869758f20785e5b0bf0cc42d4f31f9cf19a6680eb4" => :mojave
    sha256 "dd599769d423435728c2b07d60b9cc18db0cd9a64ab36baf127619c316b78721" => :high_sierra
    sha256 "370502ad0460e0506aa7aa667ed1898479f0917283481e875885ec102b25f046" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python" => [:build, :test]
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libspiro"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "libuninameslist"
  depends_on "pango"
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

  def caveats; <<~EOS
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
