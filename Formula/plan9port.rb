class Plan9port < Formula
  desc "Many Plan 9 programs ported to UNIX-like operating systems"
  homepage "https://9fans.github.io/plan9port/"
  url "https://github.com/9fans/plan9port/archive/de43b162.tar.gz"
  version "20181114"
  sha256 "4a7e3eff1ed52d49728bb5a3f9787915e38b006962e7ff8c196a556d272470de"
  head "https://github.com/9fans/plan9port.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2352217b5961f241becfd03e7f8e8ac9889c8c6cd16b7147286609f544d71025" => :mojave
    sha256 "10311cedd17e84988039e1d56152222fd6c887ddda106df55eb587d56ae65956" => :high_sierra
    sha256 "d09f0d36cf8b0ab3ecde4a78f500314ad720dea1045ae637b5ed96938b9bca87" => :sierra
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
