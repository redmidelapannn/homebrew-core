class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform."
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.0.tar.gz"
  sha256 "56e27154e033fab69ad13cedc905e2a7bf1457a79042a848fbd8370177cc9689"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b2fddf00797248ae14f72b92c3c4e574f58f7d39415700fe6766db43179ce172" => :high_sierra
    sha256 "241a3ef3ec5bf4e448987301f27e9b72b9dc958228e0cf8a76e70dffebdb10a0" => :sierra
    sha256 "b65a1184f228589a5170152b7532b109bacebffcae0af635c3042d91b87fbbf1" => :el_capitan
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
