class SdlImage < Formula
  desc "Image file loading library"
  homepage "https://www.libsdl.org/projects/SDL_image"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz"
  sha256 "0b90722984561004de84847744d566809dbb9daf732a9e503b91a1b5a84e5699"
  revision 3

  bottle do
    cellar :any
    sha256 "edea210884beb96eb7f4632e2b5d443a0e997dddb7fcb787c45abf4fd5bb907e" => :el_capitan
    sha256 "6d6f8de0347c3ff00cf6c2ad7ce395fecdeaffb31ffa0f9e0b1c6bf4b612d87c" => :yosemite
    sha256 "e8d8064dda664bdec53121858382cc94132f10f971638400bac79bf196844d35" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "webp" => :optional

  def install
    ENV.universal_binary if build.universal?
    inreplace "SDL_image.pc.in", "@prefix@", HOMEBREW_PREFIX
    args = %W[--prefix=#{prefix} --disable-dependency-tracking --disable-sdltest]
    # The alternative of ImagIO framework or libpng, jpeg, libttf and webp.
    # http://forums.libsdl.org/viewtopic.php?p=42910&sid=76c5b793b1e8f19d350a94773b1ced3b#42907
    args << "--disable-imageio"
    # --enable-feature-shared args work as inverse.
    # https://bugzilla.libsdl.org/show_bug.cgi?id=3308
    args << "--enable-jpg-shared=no" << "--enable-png-shared=no" << "--enable-tif-shared=no"
    args << "--enable-webp-shared" + (build.with?("webp") ? "=no": "")
    system "./configure", *args
    system "make", "install"
  end
end
