class Glulxe < Formula
  desc "Portable VM like the Z-machine"
  homepage "https://www.eblong.com/zarf/glulx/"
  url "https://eblong.com/zarf/glulx/glulxe-054.tar.gz"
  version "0.5.4"
  sha256 "1fc26f8aa31c880dbc7c396ede196c5d2cdff9bdefc6b192f320a96c5ef3376e"
  head "https://github.com/erkyrath/glulxe.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a5aa6a9c441967b0d0eda437fb3d1f4042f9c8fb37ca674b48c96a9153628b1a" => :high_sierra
    sha256 "acd2ab369df3549a3edcbb190f086c2fe25d8a9fbbb9e28ab8dd4635ea009fd3" => :sierra
    sha256 "29737f0c77f6811685c6b7c5aae9c2d4de89371b2d1dd00cb60e21c4bf6d366b" => :el_capitan
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

    inreplace "Makefile", "GLKINCLUDEDIR = ../cheapglk", "GLKINCLUDEDIR = #{glk.include}"
    inreplace "Makefile", "GLKLIBDIR = ../cheapglk", "GLKLIBDIR = #{glk.lib}"
    inreplace "Makefile", "Make.cheapglk", "Make.#{glk.name}"

    system "make"
    bin.install "glulxe"
  end

  test do
    if build.with? "cheapglk"
      assert shell_output("#{bin}/glulxe").start_with? "Welcome to the Cheap Glk Implementation"
    else
      assert pipe_output("#{bin}/glulxe -v").start_with? "GlkTerm, library version"
    end
  end
end
