class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/release-4.7.3/stella-4.7.3-src.tar.xz"
  sha256 "93a75d1b343b1e66b6dc526c0f9d8a0c3678d346033f7cdfe76dc93f14d956ad"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ca9ee2b365f215ba22c598250b1bc4a9d0b29810e37440a1ea97583899063e9b" => :sierra
    sha256 "4b9e313e026428854cb946591236df3fdb7b1e14a3f4f99ec237cc1881c71ac8" => :el_capitan
    sha256 "9e2a8358e6b16b871736461a687c289698fd69ea298877981cd9ef6a03b631f2" => :yosemite
  end

  depends_on :xcode => :build
  depends_on "sdl2"
  depends_on "libpng"

  def install
    cd "src/macosx" do
      inreplace "stella.xcodeproj/project.pbxproj" do |s|
        s.gsub! %r{(\w{24} \/\* SDL2\.framework)}, '//\1'
        s.gsub! %r{(\w{24} \/\* png)}, '//\1'
        s.gsub! /(HEADER_SEARCH_PATHS) = \(/, "\\1 = (#{Formula["sdl2"].include}/SDL2, #{Formula["libpng"].include},"
        s.gsub! /(LIBRARY_SEARCH_PATHS) = \.;/, "\\1 = (#{Formula["sdl2"].lib}, #{Formula["libpng"].lib}, .);"
        s.gsub! /(OTHER_LDFLAGS) = "((-\w+)*)"/, '\1 = "-lSDL2 -lpng \2"'
      end
      xcodebuild "SYMROOT=build"
      prefix.install "build/Default/Stella.app"
      bin.write_exec_script "#{prefix}/Stella.app/Contents/MacOS/Stella"
    end
  end

  test do
    assert_match /Stella version #{version}/, shell_output("#{bin}/Stella -help").strip
  end
end
