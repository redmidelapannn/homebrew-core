class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.7.3.tar.gz"
  sha256 "6d5e8ab6f87d3d9fa85af2543db838568dbdfcecd6797f8153f1b3a10b4a8bdd"
  revision 2
  head "https://github.com/mgba-emu/mgba.git"

  bottle do
    sha256 "c3f38658e3002f7de0eba4fa4e0dbd288a2b972ffcf68e37d61d262627b0186e" => :catalina
    sha256 "7c22e3ad302b737e0085b0f68feeee6f6f200c855842be6d9eefe7c8b2b66052" => :mojave
    sha256 "c1d6c21b2f16637e780102be8c045fb0d01892defd7068b1e24defb6717948d0" => :high_sierra
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
