class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://www.supermodel3.com/"
  url "https://www.supermodel3.com/Files/Supermodel_0.2a_Src.zip"
  sha256 "ecaf3e7fc466593e02cbf824b722587d295a7189654acb8206ce433dcff5497b"
  head "https://svn.code.sf.net/p/model3emu/code/trunk"

  bottle do
    rebuild 2
    sha256 "daed69e344c3ffcbb353e9742867c840ce42799ab4cee7303150de4759c73dfb" => :mojave
    sha256 "7b884718b34f409bcef413c40d063d1b067dab3687bf9a153dd1b0ec28f3002b" => :high_sierra
    sha256 "1d6f8e6f9a4d77601ee1d5999fe9b7d42b9998fdd399acde4f690c2c21239354" => :sierra
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
