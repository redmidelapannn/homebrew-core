class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.1.0.tar.gz"
  sha256 "d5598c617d03b937c8ecb84e4c0853b88ea874c2e1b6767053dc500e180aac79"

  bottle do
    cellar :any
    sha256 "c79ec420cf23db7e7de8267fd0c3086a17cf159fad1b396fac858435466b602c" => :high_sierra
    sha256 "fd3b4eba3ec1716285a077a2480fc03cd1e6f72df687364c57cdf49937094676" => :sierra
    sha256 "1c862e2162e78a3db4e26de3ee297b5b4b6a1b259a40a9dfdd728389ba540ec6" => :el_capitan
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
