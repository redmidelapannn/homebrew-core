class Breakpad < Formula
  desc "Components implement a crash-reporting system."
  homepage "https://chromium.googlesource.com/breakpad/breakpad/"
  url "https://chromium.googlesource.com/breakpad/breakpad.git",
      :revision => "67d5567177301d0c24303f26ad119ab7bd7fab40"
  version "1.0.0"
  head "https://chromium.googlesource.com/breakpad/breakpad.git"

  bottle do
    cellar :any
    sha256 "6b245db8af6719b513e14dfc24f00df909c9733c132ac5fa1b6e3147dd807b65" => :el_capitan
    sha256 "edf32650b2089226c00167c8f702c04287724c1c81fa27d16c3fe0301298c16e" => :yosemite
    sha256 "b8acaccebc4f3cf4c483949566fba585a6820309cdad9dc825d4c78397f52873" => :mavericks
  end

  depends_on :xcode => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    args = %W[
      -configuration Release
      SYMROOT=build
      PREFIX=#{prefix}
      ONLY_ACTIVE_ARCH=YES
      build
    ]

    xcodebuild "-project", "src/client/mac/Breakpad.xcodeproj", *args

    lib.install "src/client/mac/build/Release/Breakpad.framework"
    frameworks.install_symlink Dir["#{lib}/*.framework"]
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end

    xcodebuild "-project", "src/tools/mac/dump_syms/dump_syms.xcodeproj", *args

    bin.install "src/tools/mac/dump_syms/build/Release/dump_syms"
  end

  test do
    (testpath/"test.m").write <<-EOS.undent
      #import <Foundation/Foundation.h>
      #import <Breakpad/Breakpad.h>

      int main() {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

        NSDictionary *plist = [[NSBundle mainBundle] infoDictionary];

        BreakpadRef breakpad = BreakpadCreate(plist);

        BreakpadRelease(breakpad);

        [pool release];

        return 0;
      }
      EOS

    system ENV.cc, "-ObjC", "-g", "test.m", "-o", "test",
                   "-framework", "Foundation",
                   "-framework", "Breakpad", "-F", frameworks
    system "./test"
  end
end
