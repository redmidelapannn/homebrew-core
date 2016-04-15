class SdlImage < Formula
  desc "Image file loading library"
  homepage "https://www.libsdl.org/projects/SDL_image"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz"
  sha256 "0b90722984561004de84847744d566809dbb9daf732a9e503b91a1b5a84e5699"
  revision 3

  bottle do
    cellar :any
    sha256 "c833f35d715f6e247ae66cfde51faccb34fa246b146e0262662f8c38ff382fd8" => :el_capitan
    sha256 "f5240e13f82eebe769e860d52e6f74bdc2d629a2488583dafbc030b00f608ee6" => :yosemite
    sha256 "ed3696e1bc379b6b7b115c84c1f58d1031b4903e169ab7becc95e0f9815c2fb7" => :mavericks
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
