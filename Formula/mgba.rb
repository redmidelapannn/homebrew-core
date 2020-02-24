class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.8.1.tar.gz"
  sha256 "df136ea50c9cca380ab93e00fd8d87811e41a49a804c5b0e018babef0c490f13"
  head "https://github.com/mgba-emu/mgba.git"

  bottle do
    rebuild 1
    sha256 "00f5c77a71603030f03622e4dedaaceb88067d837c49712e13909eebdc56e1c3" => :catalina
    sha256 "54284d1a6ac505d8c025555cac72b146d402f162d33c908b7bf9dc807b7692f1" => :mojave
    sha256 "89de123514a39cf6fc388e17302a916dc917b8f2970df5e42a0edd7e142f9970" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
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
