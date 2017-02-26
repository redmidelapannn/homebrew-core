class SdlTtf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://www.libsdl.org/projects/SDL_ttf/"
  url "https://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.11.tar.gz"
  sha256 "724cd895ecf4da319a3ef164892b72078bd92632a5d812111261cde248ebcdb7"

  bottle do
    cellar :any
    rebuild 3
    sha256 "94d584eba1e2598bb12337f8a1f76a7c89c522c0f4ed2c3acdb0756f27b39fae" => :sierra
    sha256 "850a39fee68d80aa47cc886ce74615d237a8e8bbac07f78e5d368fc052604598" => :el_capitan
    sha256 "62880b489e6936f8a84155e0c61ecce0e09d5088a8aff9001297f37a4dd41ad6" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "freetype"

  # Fix broken TTF_RenderGlyph_Shaded()
  # https://bugzilla.libsdl.org/show_bug.cgi?id=1433
  patch do
    url "https://gist.githubusercontent.com/tomyun/a8d2193b6e18218217c4/raw/8292c48e751c6a9939db89553d01445d801420dd/sdl_ttf-fix-1433.diff"
    sha256 "4c2e38bb764a23bc48ae917b3abf60afa0dc67f8700e7682901bf9b03c15be5f"
  end

  def install
    inreplace "SDL_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make", "install"
  end
end
