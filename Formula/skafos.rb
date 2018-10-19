class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.7.4.tar.gz"
  sha256 "e6b9ce8b68ce03dbff0438ddd51f724a431ace23e2de3884f02463678832a73f"

  bottle do
    cellar :any
    sha256 "527a10b322e5c50a055741718295974c56c9f7c3a413fbe565c10315e7c254cc" => :mojave
    sha256 "5369742876993c88598c41447dd9e3980148c5eff04a424891c0d07fd8015f2b" => :high_sierra
    sha256 "5614d5ca6cc96e4630912cdabdf4a440b4cc3b8c05908f9b6b77c219926fe486" => :sierra
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
