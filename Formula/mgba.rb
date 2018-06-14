class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  revision 2
  head "https://github.com/mgba-emu/mgba.git"

  stable do
    url "https://github.com/mgba-emu/mgba/archive/0.6.3.tar.gz"
    sha256 "35c8906c01206adae714fee9c2bc39698c514a4adb32c9c4a5a3fa58b2d10f9a"

    # Fix build with Qt 5.11.0
    # https://github.com/Homebrew/homebrew-core/issues/28455
    patch do
      url "https://github.com/mgba-emu/mgba/commit/7f41dd35417.patch?full_index=1"
      sha256 "14a3c1100830d13f0e6e1656b502c34cfc527b6e4db0d47a07e613caa622d47d"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "42ba67302c001f48175a3575902a51bddd8219ec4b35796bab870e80c7c7ef85" => :high_sierra
    sha256 "1c0b9f422a408cd8c7ce2d763bb8bcd482be08b6ddf23fe5f6c142af3f823e4a" => :sierra
    sha256 "080a0bf5c44fd3046f14af3678b42bf2d31277f49f6f0fe928c4305589c7953b" => :el_capitan
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
