class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.3.0.tar.gz"
  sha256 "e7829bcdf0ecf1d2f65b959427f950bec6d44843099c1c84dbac04ca683036f8"

  bottle do
    cellar :any
    sha256 "3ca90bc729d3311d2c467e4c6193280279bf980b2d00038569d2ec84fc642fb0" => :high_sierra
    sha256 "6f48d7eb1bdb2f633e8da3554ff6f3906c4f0b0c26130525dc61d2ce8cb1c838" => :sierra
    sha256 "af1b491516a0dce3db26c01c93a25ee43008962a7cdab6e20e9ae2915e7d9801" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libarchive"
  depends_on "yaml-cpp"

  def install
    system "make", "_create_version_h"
    system "make", "_env_for_prod"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/skafos setup
      set timeout 5
        expect {
          timeout { exit 1 }
          "Please enter email:"
        }
        send "me@foo.bar\r"
        expect {
          timeout { exit 2 }
          "Please enter password:"
        }
      send "1234\r"
      expect {
        timeout { exit 3 }
        eof
      }
    EOS
    assert_match "Invalid email or password", shell_output("expect -f test.exp")
  end
end
