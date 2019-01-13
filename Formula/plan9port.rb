class Plan9port < Formula
  desc "Many Plan 9 programs ported to UNIX-like operating systems"
  homepage "https://swtch.com/plan9port/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/plan9port/plan9port-20140306.tgz"
  sha256 "cbb826cde693abdaa2051c49e7ebf75119bf2a4791fe3b3229f1ac36a408eaeb"
  head "https://github.com/9fans/plan9port.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dba2c5a3111be670e7db1488c4924fb98bc7bb23414cc78899112f3fa67dee59" => :mojave
    sha256 "0db7d79518acbe41e2cc00e7ecbd3bcb2885541cffcf47f7059b88fffe8b6941" => :high_sierra
    sha256 "964fa1436c3abda12d313ac875206f3477f1801d5cefd364c78a569e97dd2b25" => :sierra
  end

  def install
    ENV["PLAN9_TARGET"] = libexec

    system "./INSTALL"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/9"
    prefix.install Dir[libexec/"mac/*.app"]
  end

  def caveats; <<~EOS
    In order not to collide with macOS system binaries, the Plan 9 binaries have
    been installed to #{opt_libexec}/bin.
    To run the Plan 9 version of a command simply call it through the command
    "9", which has been installed into the Homebrew prefix bin.  For example,
    to run Plan 9's ls run:
        # 9 ls
  EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <u.h>
      #include <libc.h>
      #include <stdio.h>

      int main(void) {
        return printf("Hello World\\n");
      }
    EOS
    system bin/"9", "9c", "test.c"
    system bin/"9", "9l", "-o", "test", "test.o"
    assert_equal "Hello World\n", shell_output("./test", 1)
  end
end
