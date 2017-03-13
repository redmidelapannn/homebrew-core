class Irrlicht < Formula
  desc "Realtime 3D engine"
  homepage "https://irrlicht.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/irrlicht/Irrlicht%20SDK/1.8/1.8.4/irrlicht-1.8.4.zip"
  sha256 "f42b280bc608e545b820206fe2a999c55f290de5c7509a02bdbeeccc1bf9e433"
  head "https://svn.code.sf.net/p/irrlicht/code/trunk"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1298ea154514a591dbf1915a7b47973af893e2b14fe3c05cde6e0bbd36db9bf2" => :sierra
    sha256 "bff0800a22f0052282a2f48c9220318b1d4c5d5a52c8dcc9aa090006e3b204ad" => :el_capitan
    sha256 "c0970ac2498bd177d7ddaeca6c42b951a62ab85c4919654f0091fae12babbba6" => :yosemite
  end

  depends_on :xcode => :build

  def install
    # Fix "error: cannot initialize a parameter of type
    # 'id<NSApplicationDelegate> _Nullable' with an rvalue of type
    # 'id<NSFileManagerDelegate>'"
    # Reported 5 Oct 2016 https://irrlicht.sourceforge.io/forum/viewtopic.php?f=7&t=51562
    inreplace "source/Irrlicht/MacOSX/CIrrDeviceMacOSX.mm",
      "[NSApp setDelegate:(id<NSFileManagerDelegate>)",
      "[NSApp setDelegate:(id<NSApplicationDelegate>)"

    xcodebuild "-project", "source/Irrlicht/MacOSX/MacOSX.xcodeproj",
               "-configuration", "Release",
               "-target", "libIrrlicht.a",
               "SYMROOT=build"
    lib.install "source/Irrlicht/MacOSX/build/Release/libIrrlicht.a"
    include.install "include" => "irrlicht"
  end

  test do
    assert_match "x86_64", shell_output("lipo -info #{lib}/libIrrlicht.a")
  end
end
