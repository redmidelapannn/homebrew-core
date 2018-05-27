class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0197.tar.gz"
  version "0.197"
  sha256 "2ce7d6f79cdad2c904924db0eba90368026b6bc38ab7b0d1cc5792560b2dcedd"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8c3e35edd1a4778ba53a12364ac057ae221caa22c7d97d24ab1e000a8d517f94" => :high_sierra
    sha256 "dce2cc379d1f14221f960dea09b18b04dbda52b9968ee178771247b7bfe1963f" => :sierra
    sha256 "06b8f7f05f710bd5ce78da7255d32d8098a546261ad71f0da29ff4fe2b2483c5" => :el_capitan
  end

  depends_on :macos => :yosemite
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "sdl2"
  depends_on "jpeg"
  depends_on "flac"
  depends_on "lua"
  depends_on "sqlite"
  depends_on "portmidi"
  depends_on "portaudio"
  depends_on "utf8proc"

  # Need C++ compiler and standard library support C++14.
  needs :cxx14

  # jpeg 9 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2b7053a/mame/jpeg9.patch"
    sha256 "be8095e1b519f17ac4b9e6208f2d434e47346d8b4a8faf001b68749aac3efd20"
  end

  def install
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    # 3rdparty/sol2/sol/compatibility/version.hpp:30:10
    # fatal error: 'lua.hpp' file not found
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"

    system "make", "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_JPEG=1",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_LUA=1",
                   "USE_SYSTEM_LIB_SQLITE3=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1",
                   "USE_SYSTEM_LIB_PORTAUDIO=1",
                   "USE_SYSTEM_LIB_UTF8PROC=1"
    bin.install "mame64" => "mame"
    cd "docs" do
      system "make", "text"
      doc.install Dir["build/text/*"]
      system "make", "man"
      man1.install "build/man/MAME.1" => "mame.1"
    end
    pkgshare.install %w[artwork bgfx hash ini keymaps plugins samples uismall.bdf]
  end

  test do
    assert shell_output("#{bin}/mame -help").start_with? "MAME v#{version}"
    system "#{bin}/mame", "-validate"
  end
end
