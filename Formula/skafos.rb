class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.2.tar.gz"
  sha256 "fedff898ef97280712ea4bc5ae8b9c696e09b698b3cc035b4fb88d7134ae8018"

  bottle do
    cellar :any
    sha256 "7250bf5ebac3abeced911cbfcc3ad9ce022ab5e92c5db5097cb4fceba4f12fce" => :high_sierra
    sha256 "bd7d2d46e59b14f52dfbafe98a6044921854fdb39a8a355074602babd28431c1" => :sierra
    sha256 "ca957a25a53a0b5ad7bdf9a4ad4c7e7ec3f17bc5c44f204e163c3a82648237de" => :el_capitan
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
