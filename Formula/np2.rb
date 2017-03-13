class Np2 < Formula
  desc "Neko Project 2: PC-9801 emulator"
  homepage "http://www.yui.ne.jp/np2/"
  if MacOS.version >= :sierra
    url "https://amethyst.yui.ne.jp/svn/pc98/np2/tags/VER_0_86/", :using => :svn, :revision => "2606"
  else
    url "http://amethyst.yui.ne.jp/svn/pc98/np2/tags/VER_0_86/", :using => :svn, :revision => "2606"
  end
  head "https://amethyst.yui.ne.jp/svn/pc98/np2/trunk/", :using => :svn

  bottle do
    cellar :any
    rebuild 1
    sha256 "183e56eee688049cb8f35fb6eebc347f5521fc4b1b4239b9b7195d5416436fd0" => :sierra
    sha256 "e146c1633c85f7d341fd46190e950f434b75d0ecbc9be16aa50dfaece427ab88" => :el_capitan
    sha256 "147abb19f3e676093e76a16b3e5b85935ee6eb56071fd245c87e614057267369" => :yosemite
  end

  depends_on :xcode => :build
  depends_on "sdl2"
  depends_on "sdl2_ttf"

  def install
    sdl2 = Formula["sdl2"]
    sdl2_ttf = Formula["sdl2_ttf"]

    cd "sdl2/MacOSX" do
      # Use brewed library paths
      inreplace "np2sdl2.xcodeproj/project.pbxproj" do |s|
        s.gsub! "BAF84E4B195AA35E00183062", "//BAF84E4B195AA35E00183062"
        s.gsub! "HEADER_SEARCH_PATHS = (", "LIBRARY_SEARCH_PATHS = (\"$(inherited)\", #{sdl2.lib}, #{sdl2_ttf.lib}); HEADER_SEARCH_PATHS = (#{sdl2.include}/SDL2, #{sdl2.include}, #{sdl2_ttf.include},"
        s.gsub! "buildSettings = {", 'buildSettings ={ OTHER_LDFLAGS = "-lSDL2 -lSDL2_ttf";'
      end
      # Force to use Japanese TTF font
      inreplace "np2sdl2/compiler.h", "#define RESOURCE_US", ""
      # Always use current working directory
      inreplace "np2sdl2/main.m", "[pstrBundlePath UTF8String]", '"./"'

      xcodebuild "SYMROOT=build"
      bin.install "build/Release/np2sdl2.app/Contents/MacOS/np2sdl2" => "np2"
    end
  end

  def caveats; <<-EOS.undent
    A Japanese TTF file named `default.ttf` should be in the working directory.
    EOS
  end

  test do
    assert_match %r{Usage: #{bin}/np2}, shell_output("#{bin}/np2 -h", 1)
  end
end
