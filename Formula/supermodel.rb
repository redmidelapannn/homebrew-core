class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://www.supermodel3.com/"
  url "https://www.supermodel3.com/Files/Supermodel_0.2a_Src.zip"
  sha256 "ecaf3e7fc466593e02cbf824b722587d295a7189654acb8206ce433dcff5497b"
  head "https://svn.code.sf.net/p/model3emu/code/trunk"

  bottle do
    rebuild 2
    sha256 "098d4ad311ae2df7f14093471a5e1e14735c78b853d579f2707333092641e77e" => :catalina
    sha256 "fbb4a3d69ad4b247159e7ae59db8f2ccce09c77bfbf52535bb60b75250f12729" => :mojave
    sha256 "204e017f9bc5578447b5051951a022a828584a7e53a68fdc4061bcb33bf62c78" => :high_sierra
  end

  depends_on "sdl"

  def install
    makefile_dir = build.head? ? "Makefiles/Makefile.OSX" : "Makefiles/Makefile.SDL.OSX.GCC"
    inreplace makefile_dir do |s|
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

    system "make", "-f", makefile_dir
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
