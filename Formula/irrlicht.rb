class Irrlicht < Formula
  desc "Realtime 3D engine"
  homepage "http://irrlicht.sourceforge.net/"
  url "https://downloads.sourceforge.net/irrlicht/irrlicht-1.8.3.zip"
  sha256 "9e7be44277bf2004d73580a8585e7bd3c9ce9a3c801691e4f4aed030ac68931c"

  head do
    url "https://irrlicht.svn.sourceforge.net/svnroot/irrlicht/trunk"

    # may be removed when https://sourceforge.net/p/irrlicht/patches/297/ will
    # be applied
    if MacOS.version == :yosemite
      patch do
        url "https://raw.githubusercontent.com/Homebrew/patches/da81091065df021758e02b9e07e36eaba20c4ec3/irrlicht/yosemite-head.patch"
        sha256 "32e4a964a50325489ec1598bd6ca3e24f4c773bca74cc59f585fb2703d7e6d46"
      end
    end
  end

  # may be removed when https://sourceforge.net/p/irrlicht/patches/297/ will
  # be applied
  stable do
    if MacOS.version == :yosemite
      patch do
        url "https://raw.githubusercontent.com/Homebrew/patches/da81091065df021758e02b9e07e36eaba20c4ec3/irrlicht/yosemite.patch"
        sha256 "2dca39defb1044acaa87f6c8975283ce153c3f5e0ee0971565e490da8c12a496"
      end
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "59fe484643b534ba341f733836e885a0f9c0a9f176b4694903979092a86e5e09" => :el_capitan
    sha256 "78558e133816942a180fc079abe29bac63d4e346c3688a0d66bd57a3f616743c" => :mavericks
  end

  depends_on :xcode => :build

  def install
    xcodebuild "-project", "source/Irrlicht/MacOSX/MacOSX.xcodeproj",
               "-configuration", "Release",
               "-target", "libIrrlicht.a",
               "SYMROOT=build",
               "-sdk", "macosx#{MacOS.version}"
    lib.install "source/Irrlicht/MacOSX/build/Release/libIrrlicht.a"
    include.install "include" => "irrlicht"
  end
end
