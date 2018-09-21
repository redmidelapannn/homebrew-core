class Onscripter < Formula
  desc "NScripter-compatible visual novel engine"
  homepage "https://onscripter.osdn.jp/"
  url "https://onscripter.osdn.jp/onscripter-20170814.tar.gz"
  sha256 "07010e633e490f24f4c5a57dd8c7979f519d0a10a2bfbba8e04828753f1ba97a"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "3839435f4ffe7c0e8d0f9224b96436eeaf5d186ff3d8e5bf769e2f0e9b2e03cc" => :mojave
    sha256 "733a0e64cd083ee1e7aa016eac74e0a9f2a13b56f9968f349b68d5d28eab6552" => :high_sierra
    sha256 "dd77c6bb1a5431e3d0268d659e883d127f867cffac87327460443ee3fd086d98" => :sierra
    sha256 "8f9fa92653305887302ce79b7ca7f441552212411b7151fcee5e5ff953ede895" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "lua"
  depends_on "sdl"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"
  depends_on "smpeg"

  # jpeg 9 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/eeb2de3/onscripter/jpeg9.patch"
    sha256 "08695ddcbc6b874b903694ac783f7c21c61b5ba385572463d17fbf6ed75f60a1"
  end

  def install
    incs = [
      `pkg-config --cflags sdl SDL_ttf SDL_image SDL_mixer`.chomp,
      `smpeg-config --cflags`.chomp,
      "-I#{Formula["jpeg"].include}",
      "-I#{Formula["lua"].opt_include}/lua",
    ]

    libs = [
      `pkg-config --libs sdl SDL_ttf SDL_image SDL_mixer`.chomp,
      `smpeg-config --libs`.chomp,
      "-ljpeg",
      "-lbz2",
      "-L#{Formula["lua"].opt_lib} -llua",
    ]

    defs = %w[
      -DMACOSX
      -DUSE_CDROM
      -DUSE_LUA
      -DUTF8_CAPTION
      -DUTF8_FILESYSTEM
    ]

    ext_objs = ["LUAHandler.o"]

    k = %w[INCS LIBS DEFS EXT_OBJS]
    v = [incs, libs, defs, ext_objs].map { |x| x.join(" ") }
    args = k.zip(v).map { |x| x.join("=") }
    system "make", "-f", "Makefile.MacOSX", *args
    bin.install %w[onscripter sardec nsadec sarconv nsaconv]
  end

  test do
    assert shell_output("#{bin}/onscripter -v").start_with? "ONScripter version #{version}"
  end
end
