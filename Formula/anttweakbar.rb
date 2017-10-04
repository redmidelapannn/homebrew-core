class Anttweakbar < Formula
  desc "C/C++ library for adding GUIs to OpenGL apps"
  homepage "https://anttweakbar.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/anttweakbar/AntTweakBar_116.zip"
  version "1.16"
  sha256 "fbceb719c13ceb13b9fd973840c2c950527b6e026f9a7a80968c14f76fcf6e7c"

  bottle do
    cellar :any
    rebuild 2
    sha256 "c98032aa289ff653ce06ff34e90e55e33b8b0e4448c0ddf61511297550e24f83" => :high_sierra
    sha256 "edb2915a7cb0067113e9330ba9fba03e7a462f564692c60821b102f4a56dbe2b" => :sierra
    sha256 "ece8ca4f9d062b9d66ba53fea612e6a33fde582dd2c51f47f1790b3422d03f03" => :el_capitan
  end

  # See:
  # https://sourceforge.net/p/anttweakbar/code/ci/5a076d13f143175a6bda3c668e29a33406479339/tree/src/LoadOGLCore.h?diff=5528b167ed12395a60949d7c643262b6668f15d5&diformat=regular
  # https://sourceforge.net/p/anttweakbar/tickets/14/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/62e79481/anttweakbar/anttweakbar.diff"
    sha256 "3be2cb71cc00a9948c8b474da7e15ec85e3d094ed51ad2fab5c8991a9ad66fc2"
  end

  def install
    # Work around Xcode 9 error "no member named 'signbit' in the global
    # namespace" and Xcode 8 issue on El Capitan "error: missing ',' between
    # enumerators"
    if DevelopmentTools.clang_build_version >= 900 ||
       (MacOS.version == :el_capitan && MacOS::Xcode.installed? &&
       MacOS::Xcode.version >= "8.0")
      ENV.delete("SDKROOT")
    end

    system "make", "-C", "src", "-f", "Makefile.osx"
    lib.install "lib/libAntTweakBar.dylib", "lib/libAntTweakBar.a"
    include.install "include/AntTweakBar.h"
  end
end
