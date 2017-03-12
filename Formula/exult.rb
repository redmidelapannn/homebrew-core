class Exult < Formula
  desc "Recreation of Ultima 7"
  homepage "https://exult.sourceforge.io/"
  # TODO: move to: https://github.com/exult/exult
  if MacOS.version >= :sierra
    url "https://svn.code.sf.net/p/exult/code/exult/trunk", :revision => 7520
  else
    url "http://svn.code.sf.net/p/exult/code/exult/trunk", :revision => 7520
  end

  version "1.4.9rc1+r7520"
  head "https://github.com/exult/exult.git"

  bottle do
    rebuild 1
    sha256 "41e8ccea867deec0c20068d3fdd1c46c2f865cc0f9413274877b6248dd687bdf" => :sierra
    sha256 "ca0c5208537a51add94b9376edb4686e06f0db66ad7059044e51d0e86f15cd0f" => :el_capitan
    sha256 "3470b16594b1b8e20230626d2689626ed32031b90a26e84e955fb9d42216d128" => :yosemite
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
