class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     :tag      => "0.5.0",
     :revision => "3be22875e27f220350d8ab5b13403d804acfd20b"
  head "https://github.com/arduino/arduino-cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "142339302a573802571d96559bb909231cf89e958b1954fbb216a88a55c11ec0" => :catalina
    sha256 "6baf6d51da9e16b8d1cc72b01506c052f4313d63698e3c8a3a7628ffeee04cf8" => :mojave
    sha256 "9c6bf9246244b5cf4c2aecdddc99d76853d4702c2839fb157deb9f63e879c686" => :high_sierra
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
    assert File.directory?("#{testpath}/Documents/Arduino/test_sketch")
  end
end
