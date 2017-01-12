class Libui < Formula
  desc "portable GUI library for C"
  homepage "https://github.com/andlabs/libui"
  url "https://github.com/andlabs/libui/archive/alpha3.1.tar.gz"
  sha256 "945ee9abacffafa93b5cf941bddfbe0bd0d4b3a8c7f8b0256779e24249f57679"

  head "https://github.com/andlabs/libui/libui.git"

  bottle do
    cellar :any
    sha256 "73196681bdcbad3d03acef4a182d3c314abb991800c6eb533f3f529d1fa13bb1" => :sierra
    sha256 "c054c0cca53183cb1cc8f165082213b9d497fdeee15a5168d3c13f87abc6b124" => :el_capitan
    sha256 "0ae44db65da0d3880a70851a7d1c7bb301d812409a4e2397b47b3f6d0f855042" => :yosemite
  end

  option "without-shared-library", "Build static library only (defaults to building dylib only)"
  option "with-examples", "Build examples"
  option "with-tester", "Build tester program"

  depends_on "cmake" => :build

  def install
    args = []
    args << "-DBUILD_SHARED_LIBS=OFF" if build.without? "shared-library"
    args << ".."

    mkdir "build" do
      system "cmake", *args
      system "make"
      system "make", "examples" if build.with? "examples"
      system "make", "tester" if build.with? "tester"

      Dir.chdir("out")
      libexec.install "controlgallery", "cpp-multithread", "histogram" if build.with? "examples"
      libexec.install "test" if build.with? "test"
    end

    include.install "ui.h", "ui_darwin.h"
    lib.install Dir["build/out/libui.*"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <ui.h>
      uiWindow *mainwin;
      int main(void) {
        mainwin = uiNewWindow("libui test", 640, 480, 1);
        uiQuit();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test",
           "-I#{include}", "-L#{lib}", "-lui",
           "-framework", "Cocoa"
    system "./test"
  end
end
