class Exult < Formula
  desc "Recreation of Ultima 7"
  homepage "https://exult.sourceforge.io/"
  url "https://github.com/exult/exult.git", :revision => "75aff2e97a4867d7810f8907796f58cb11b87a39"
  version "1.4.9rc1+r7520"
  head "https://github.com/exult/exult.git"

  bottle do
    rebuild 1
    sha256 "21fb7e19e74f62bc16cbca8b8e52f37c382e0989d013ddd7d76699008d56774b" => :sierra
    sha256 "0440177bdc2d6e10f155f49e6136eadaa0aa522889306fec128de0683e691734" => :el_capitan
    sha256 "34401c1ab3a280c102b82e5a3b0575de6508bab13fc18969a768c0377b408dcc" => :yosemite
  end

  option "with-audio-pack", "Install audio pack"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "libogg"
  depends_on "libvorbis"

  resource "audio" do
    url "https://downloads.sourceforge.net/project/exult/exult-data/exult_audio.zip"
    sha256 "72e10efa8664a645470ceb99f6b749ce99c3d5fd1c8387c63640499cfcdbbc68"
  end

  def install
    # Use ~/Library/... instead of /Library for the games
    inreplace "files/utils.cc" do |s|
      s.gsub! /(gamehome_dir)\("\."\)/, '\1(home_dir)'
      s.gsub! /(gamehome_dir) =/, '\1 +='
    end

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "EXULT_DATADIR=#{pkgshare}/data"
    system "make", "bundle"
    pkgshare.install "Exult.app/Contents/Resources/data"
    (pkgshare/"data").install resource("audio") if build.with? "audio-pack"
    prefix.install "Exult.app"
    bin.write_exec_script "#{prefix}/Exult.app/Contents/MacOS/exult"
  end

  def caveats; <<-EOS.undent
    Note that this includes only the game engine; you will need to supply your own
    own legal copy of the Ultima 7 game files. Try here (amazon.com):
      https://bit.ly/8JzovU

    Update audio settings accordingly with configuration file:
      ~/Library/Preferences/exult.cfg

      To use CoreAudio, set `driver` to `CoreAudio`.
      To use audio pack, set `use_oggs` to `yes`.
    EOS
  end

  test do
    system "#{bin}/exult", "-v"
  end
end
