class Solfege < Formula
  desc "GNU Solfege is an ear training program"
  homepage "https://www.gnu.org/software/solfege/"
  url "https://ftp.gnu.org/gnu/solfege/solfege-3.22.2.tar.bz2"
  mirror "https://ftpmirror.gnu.org/solfege/solfege-3.22.2.tar.bz2"
  sha256 "5a6fcd46b0ce33817752f5b04e053b5342d8d2e3c8b3df2ea789cf3366a38b10"

  bottle do
    cellar :any_skip_relocation
    sha256 "a32ce318647fef4a5c503de1a40f2f80ac1792dc885aba0a704e3dc73283b102" => :mojave
    sha256 "a13a002a97e51080f833745bda9c106bc2d24bdd424d2088809ad06a22eb379e" => :high_sierra
    sha256 "a13a002a97e51080f833745bda9c106bc2d24bdd424d2088809ad06a22eb379e" => :sierra
  end

  depends_on "gettext"      => :build
  depends_on "pkg-config"   => :build
  depends_on "librsvg"
  depends_on "pygtk"
  depends_on "timidity"     => :recommended
  depends_on "mpg123"       => :optional
  depends_on "vorbis-tools" => :optional

  def install
    inreplace "Makefile.in", "cp --parents", "rsync -R"
    inreplace "default.config", "/usr/bin/", "#{HOMEBREW_PREFIX}/bin/"
    inreplace "solfege/mainwin.py", "webbrowser.open(filename)", "webbrowser.open(\"file://\" + filename)"

    system "./configure", "--prefix=#{prefix}", "--disable-oss-sound"
    system "make", "install"
  end

  test do
    system "#{bin}/solfege", "--version"
  end
end
