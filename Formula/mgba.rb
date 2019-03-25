class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.7.1.tar.gz"
  sha256 "665fbae8bcfaf3e3f4b83267ce5800b00b98f4bacbb36fc412e3829020019cf4"
  head "https://github.com/mgba-emu/mgba.git"

  bottle do
    cellar :any
    sha256 "05f047199b814a992bd330dae526874a425f52d0e0ef674b4040950d0053b4ec" => :mojave
    sha256 "b35eb17585007f58d73104a6cee5c9fd4ade4073f714f8cd4d595eeb9b1e9073" => :high_sierra
    sha256 "c4a7b9598e074a904a466d4f7f540a67c511131f780a6898b1b8def3e33058ba" => :sierra
    sha256 "fafaa47a86e92ad1877814abcf7a6d7159188e02ba2e63ad8f171116d49f5546" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "imagemagick"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libzip"
  depends_on "qt"
  depends_on "sdl2"

  def install
    # Fix "error: 'future<void>' is unavailable: introduced in macOS 10.8"
    # Reported 11 Dec 2017 https://github.com/mgba-emu/mgba/issues/944
    if MacOS.version <= :el_capitan
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    end

    # Install .app bundle into prefix, not prefix/Applications
    inreplace "src/platform/qt/CMakeLists.txt", "Applications", "."

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    # Replace SDL frontend binary with a script for running Qt frontend
    # -DBUILD_SDL=OFF would be easier, but disable joystick support in Qt frontend
    rm bin/"mgba"
    bin.write_exec_script "#{prefix}/mGBA.app/Contents/MacOS/mGBA"
  end

  test do
    system "#{bin}/mGBA", "-h"
  end
end
