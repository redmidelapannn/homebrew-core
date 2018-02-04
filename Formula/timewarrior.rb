class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://taskwarrior.org/docs/timewarrior/"
  url "https://taskwarrior.org/download/timew-1.1.1.tar.gz"
  sha256 "1f7d9a62e55fc5a3126433654ccb1fd7d2d135f06f05697f871897c9db77ccc9"
  head "https://github.com/GothenburgBitFactory/timewarrior.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e4962b6aa57bb12de538bbf70e2e8a70f3f5a28289d02fc6535cd8d28321fe74" => :high_sierra
    sha256 "f66480bdfbb8a265b89e68f60cc356fc0f1f3e1c1d52ac617aec8edfde0b9ac7" => :sierra
    sha256 "0cdf4e008f03ae2ec8af57e9c38b8e4c3b2fab43222fd3e023367c34e691ac12" => :el_capitan
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
