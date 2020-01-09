class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     :tag      => "0.7.2",
     :revision => "9c10e063435a813e6e9bdecc596b5d735aa8a4ec"
  head "https://github.com/arduino/arduino-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c16c5ffd514f89665f25175a85512cc68ad2663079abc4bc9b51dace69d6d75" => :catalina
    sha256 "779495d5d2899aa78b8c1057c65d0b43bdd843cd35a833f97d0162c7956e3391" => :mojave
    sha256 "f08e91fa4bad236bb1f17aaec5bc202c00d2c75a5697ec34c00bf4f322d98827" => :high_sierra
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
