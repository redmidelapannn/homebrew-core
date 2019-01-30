class Irrlicht < Formula
  desc "Realtime 3D engine"
  homepage "https://irrlicht.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/irrlicht/Irrlicht%20SDK/1.8/1.8.4/irrlicht-1.8.4.zip"
  sha256 "f42b280bc608e545b820206fe2a999c55f290de5c7509a02bdbeeccc1bf9e433"
  head "https://svn.code.sf.net/p/irrlicht/code/trunk"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "17f108de3a44f91187f6eb336b6cc26b15be90c024dcb68eeb2d1bbdbf781d09" => :sierra
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
