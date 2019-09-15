class Exult < Formula
  desc "Recreation of Ultima 7"
  homepage "https://exult.sourceforge.io/"
  url "https://github.com/exult/exult.git", :revision => "75aff2e97a4867d7810f8907796f58cb11b87a39"
  version "1.4.9rc1+r7520"
  head "https://github.com/exult/exult.git"

  bottle do
    rebuild 2
    sha256 "e67b8aa473d0791c8ea93476362436f14c3d79161ed7c70a356274442342a278" => :mojave
    sha256 "c037d2229f05cfe582a4744d4e37047822ac315bff5a43d644bf425a730065c4" => :high_sierra
    sha256 "f3f4a0cb267c071bddd714e17531de28ef270198187b12958d12cfc6532b22ef" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl2"

  # Upstream's fix for recent clang (Xcode 9)
  # https://github.com/exult/exult/commit/083ea2fa
  # Can be removed in next version
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c9cb2e28/exult/clang9.patch"
    sha256 "e661b7e2e30820bcb74938a203bd367c66c00bc2a7c8de8525e78d70a87a3bd8"
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
    prefix.install "Exult.app"
    bin.write_exec_script "#{prefix}/Exult.app/Contents/MacOS/exult"
  end

  def caveats; <<~EOS
    This formula only includes the game engine; you will need to supply your own
    own legal copy of the Ultima 7 game files for the software to fully function.

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
