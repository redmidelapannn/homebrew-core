class Onscripter < Formula
  desc "NScripter-compatible visual novel engine"
  homepage "https://onscripter.osdn.jp/"
  url "https://onscripter.osdn.jp/onscripter-20170814.tar.gz"
  sha256 "07010e633e490f24f4c5a57dd8c7979f519d0a10a2bfbba8e04828753f1ba97a"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "f3ddd3fdf0f955f289d39d42685b805b727d490e5a478324d221fb9f93878a88" => :high_sierra
    sha256 "1c6d21f4163f3fa955d4f60f9b6b849e481100f3db4bdac5c9dd6db28b2073a9" => :sierra
    sha256 "f97e023fdd93c0313b2035f7621a4711c6bf178dfad6278edc684342676020df" => :el_capitan
  end

  option "with-english", "Build with single-byte character mode"

  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "sdl_ttf"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "smpeg"
  depends_on "jpeg"
  depends_on "lua" => :recommended

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
    ]

    libs = [
      `pkg-config --libs sdl SDL_ttf SDL_image SDL_mixer`.chomp,
      `smpeg-config --libs`.chomp,
      "-ljpeg",
      "-lbz2",
    ]

    defs = %w[
      -DMACOSX
      -DUSE_CDROM
      -DUTF8_CAPTION
      -DUTF8_FILESYSTEM
    ]

    ext_objs = []

    if build.with? "lua"
      lua = Formula["lua"]
      incs << "-I#{lua.opt_include}/lua"
      libs << "-L#{lua.opt_lib} -llua"
      defs << "-DUSE_LUA"
      ext_objs << "LUAHandler.o"
    end

    if build.with? "english"
      defs += %w[
        -DENABLE_1BYTE_CHAR
        -DFORCE_1BYTE_CHAR
      ]
    end

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
