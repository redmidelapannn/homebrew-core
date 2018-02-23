class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://www.supermodel3.com/"
  url "https://www.supermodel3.com/Files/Supermodel_0.2a_Src.zip"
  sha256 "ecaf3e7fc466593e02cbf824b722587d295a7189654acb8206ce433dcff5497b"
  head "https://svn.code.sf.net/p/model3emu/code/trunk"

  bottle do
    rebuild 1
    sha256 "9ed7f77692d0c2122b910dd1237eb33f9d7f8a56f41c5084a6d935b2ab227c5e" => :high_sierra
    sha256 "39545c82ee60d82d2363def790ab9506285dd0593bdc15437b99890ef15e3e0d" => :sierra
    sha256 "eb99049d79c152cf67c7ea6d1e9cbd1d4fe0b259d941ad9c5a5cbc81b11a9f4f" => :el_capitan
  end

  depends_on "sdl"

  def install
    inreplace "Makefiles/Makefile.SDL.OSX.GCC" do |s|
      # Set up SDL library correctly
      s.gsub! "-framework SDL", "`sdl-config --libs`"
      s.gsub! /(\$\(COMPILER_FLAGS\))/, "\\1 -I#{Formula["sdl"].opt_prefix}/include"
      # Fix missing label issue for auto-generated code
      s.gsub! %r{(\$\(OBJ_DIR\)/m68k\w+)\.o: \1.c (.*)\n(\s*\$\(CC\)) \$<}, "\\1.o: \\2\n\\3 \\1.c"
    end

    # Use /usr/local/var/supermodel for saving runtime files
    inreplace "Src/OSD/SDL/Main.cpp" do |s|
      s.gsub! %r{(Config|Saves|NVRAM)/}, "#{var}/supermodel/\\1/"
      s.gsub! /(\w+\.log)/, "#{var}/supermodel/Logs/\\1"
    end

    system "make", "-f", "Makefiles/Makefile.SDL.OSX.GCC"
    bin.install "bin/Supermodel" => "supermodel"
    (var/"supermodel/Config").install "Config/Supermodel.ini"
    (var/"supermodel/Saves").mkpath
    (var/"supermodel/NVRAM").mkpath
    (var/"supermodel/Logs").mkpath
  end

  def caveats; <<~EOS
    Config, Saves, and NVRAM are located in the following directory:
      #{var}/supermodel/
    EOS
  end

  test do
    system "#{bin}/supermodel", "-print-games"
  end
end
