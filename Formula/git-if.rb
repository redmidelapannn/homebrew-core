class GitIf < Formula
  desc "Glulx interpreter that is optimized for speed"
  homepage "https://ifarchive.org/indexes/if-archiveXprogrammingXglulxXinterpretersXgit.html"
  url "https://ifarchive.org/if-archive/programming/glulx/interpreters/git/git-135.zip"
  version "1.3.5"
  sha256 "4bdfae2e1ab085740efddf99d43ded6a044f1f2df274f753737e5f0e402fc4e9"
  head "https://github.com/DavidKinder/Git.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "84cd526ce31002b950eeee6d10bba3909e1d1f35a6a91d2ed1375d81008eb7b4" => :high_sierra
    sha256 "ebb2bb05fa68d7bb03fa51230c000230393b8ee9180893840fd26accfb5e1c1e" => :sierra
    sha256 "180662e885a1c250f3d788ce30ad7ccdca6e1f6e0dd4953ffc7e97b71fe80e01" => :el_capitan
  end

  option "with-glkterm", "Build with glkterm (without wide character support)"

  depends_on "cheapglk" => [:build, :optional]
  depends_on "glkterm" => [:build, :optional]
  depends_on "glktermw" => :build if build.without?("cheapglk") && build.without?("glkterm")

  def install
    if build.with?("cheapglk") && build.with?("glkterm")
      odie "Options --with-cheapglk and --with-glkterm are mutually exclusive."
    end

    if build.with? "cheapglk"
      glk = Formula["cheapglk"]
    elsif build.with? "glkterm"
      glk = Formula["glkterm"]
    else
      glk = Formula["glktermw"]
    end

    inreplace "Makefile", "GLK = cheapglk", "GLK = #{glk.name}" if build.without? "cheapglk"
    inreplace "Makefile", "GLKINCLUDEDIR = ../$(GLK)", "GLKINCLUDEDIR = #{glk.include}"
    inreplace "Makefile", "GLKLIBDIR = ../$(GLK)", "GLKLIBDIR = #{glk.lib}"
    inreplace "Makefile", /^OPTIONS = /, "OPTIONS = -DUSE_MMAP -DUSE_INLINE"

    system "make"
    bin.install "git" => "git-if"
  end

  test do
    if build.with? "cheapglk"
      assert shell_output("#{bin}/git-if").start_with? "usage: git gamefile.ulx"
    else
      assert pipe_output("#{bin}/git-if -v").start_with? "GlkTerm, library version"
    end
  end
end
