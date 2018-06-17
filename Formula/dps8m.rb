class Dps8m < Formula
  desc "Simulator for the Multics dps-8/m mainframe"
  homepage "https://ringzero.wikidot.com"
  url "https://downloads.sourceforge.net/project/dps8m/Release%201.0/source.tgz"
  version "1.0"
  sha256 "51088dd91de888b918644c431eec22318640d28eb3050d9c01cd072aa7cca3c7"

  head "https://github.com/charlesUnixPro/dps8m.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4b8efbe2ebc494e643ce9597bcbf7d1ea33567b647193a15aab2e5daeff40acf" => :high_sierra
    sha256 "a6aa5ffaa10e8b5eb5e6278a5a0ae18a2e9b68fe4be2613021dca0f325d019d9" => :sierra
    sha256 "e4ee701ce2e607e1098dbd7130f9e129b16e3b6726c95472815e5cfa3367000e" => :el_capitan
  end

  depends_on "libuv"

  def install
    # Reported 23 Jul 2017 "make dosn't create bin directory"
    # See https://sourceforge.net/p/dps8m/mailman/message/35960505/
    bin.mkpath

    system "make", "INSTALL_ROOT=#{prefix}", "install"
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/dps8
      set timeout 5
      expect {
        timeout { exit 1 }
        "sim>"
      }
      send "help\r"
      expect {
        timeout { exit 2 }
        "SKIPBOOT"
      }
      send "q\r"
      expect {
        timeout { exit 3 }
        eof
      }
    EOS
    assert_equal "Goodbye", shell_output("expect -f test.exp").lines.last.chomp
  end
end
