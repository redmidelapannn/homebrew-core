class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     :tag      => "0.7.1",
     :revision => "7668c465dd0ed58059c51b1b1f0a06279d6f4714"
  head "https://github.com/arduino/arduino-cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "783734b67c7669fb552dd409b3efd4ba2c6dcbbf3ecbaeaec6bc277420d4a8a3" => :catalina
    sha256 "cfc3b744391ae4a4d292d0b162d84a44fcaa71a49828f56524dd2f28c602865e" => :mojave
    sha256 "a98c1a5d822d4c058029ad00a8f49fd5bf9325a1285112ca0b72f4ac7213fa17" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
    system "go", "build", "-ldflags",
           "-s -w -X github.com/arduino/arduino-cli/version.versionString=#{version} " \
           "-X github.com/arduino/arduino-cli/version.commit=#{commit}",
           "-o", bin/"arduino-cli"
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")
  end
end
