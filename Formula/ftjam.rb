class Ftjam < Formula
  desc "Build tool that can be used as a replacement for Make"
  homepage "https://www.freetype.org/jam/"
  url "https://downloads.sourceforge.net/project/freetype/ftjam/2.5.2/ftjam-2.5.2.tar.bz2"
  sha256 "e89773500a92912de918e9febffabe4b6bce79d69af194435f4e032b8a6d66a3"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "aacfdd6614f2ea187ea42af4b9c569e5047c4967f822f546f6b3e8dffb0e5429" => :el_capitan
    sha256 "895aebb571b1cd7d52901f8f6b96ce28b1125dc28f07c6a4575c9624ae2e1523" => :yosemite
    sha256 "55f0ea0ed0850d0804b9d32f9d759183329ed1b4763cd6b64e38ef3d870f280f" => :mavericks
  end

  conflicts_with "jam", :because => "both install a `jam` binary"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Jamfile").write <<-EOS.undent
      Main ftjamtest : ftjamtest.c ;
    EOS

    (testpath/"ftjamtest.c").write <<-EOS.undent
      #include <stdio.h>

      int main(void)
      {
          printf("FtJam Test\\n");
          return 0;
      }
    EOS

    assert_match "Cc ftjamtest.o", shell_output(bin/"jam")
    assert_equal "FtJam Test\n", shell_output("./ftjamtest")
  end
end
