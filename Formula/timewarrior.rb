class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://taskwarrior.org/docs/timewarrior/"
  url "https://taskwarrior.org/download/timew-1.1.1.tar.gz"
  sha256 "1f7d9a62e55fc5a3126433654ccb1fd7d2d135f06f05697f871897c9db77ccc9"
  head "https://github.com/GothenburgBitFactory/timewarrior.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0c4a0c187b6fb87ca4708471039dd53aca46a3daa54e9ef3dd44d2e77b2d537" => :high_sierra
    sha256 "1e6f7b0ef940b9dccd776c22fdbc50afbdde601bbe486d4a624f413117f5988e" => :sierra
    sha256 "3d40a1101fe375cc7f07fd240e79fa5a188505d946ca1418e8786f424fb860e5" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/".timewarrior/data").mkpath
    (testpath/".timewarrior/extensions").mkpath
    touch testpath/".timewarrior/timewarrior.cfg"
    assert_match "Tracking foo", shell_output("#{bin}/timew start foo")
  end
end
