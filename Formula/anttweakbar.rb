class Anttweakbar < Formula
  desc "C/C++ library for adding GUIs to OpenGL apps"
  homepage "https://anttweakbar.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/anttweakbar/AntTweakBar_116.zip"
  version "1.16"
  sha256 "fbceb719c13ceb13b9fd973840c2c950527b6e026f9a7a80968c14f76fcf6e7c"

  bottle do
    cellar :any
    rebuild 2
    sha256 "83a31545ca6de970f7e27f63f63eab1f12d4194bf6310329cf451c69aafac8f6" => :catalina
    sha256 "27894a0584905dd8ea45d04c2b0ea8321c7b5ef4a8a39c576b32ffffdcd12e09" => :mojave
    sha256 "fd84eeb4cc7809859170d09d10f0f3020bf17cff5438c4f03ed28c96d2b995f7" => :high_sierra
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
       (MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0")
      ENV.delete("SDKROOT")
      ENV.delete("HOMEBREW_SDKROOT")
    end

    system "make", "-C", "src", "-f", "Makefile.osx"
    lib.install "lib/libAntTweakBar.dylib", "lib/libAntTweakBar.a"
    include.install "include/AntTweakBar.h"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <AntTweakBar.h>
      int main() {
        TwBar *bar; // TwBar is an internal structure of AntTweakBar
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-anttweakbar", "-o", "test"
    system "./test"
  end
end
