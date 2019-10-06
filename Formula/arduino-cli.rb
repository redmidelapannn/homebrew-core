class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli/archive/0.5.0-showports.tar.gz"
  version "0.5.0-showports"
  sha256 "96373b59e004f277474eb5a11e2a585633976c9939056b833e65e670e7393e77"

  bottle do
    cellar :any_skip_relocation
    sha256 "08c0cd11ce824ac3fb83380d6c5649ac0fcce4fd308b1baf55ec037ac68db384" => :catalina
    sha256 "8ef55a520435a57646f4fc3bda00aa4724917aebdfe51f23b9e4ab385290702a" => :mojave
    sha256 "9bd1eb7045a7f34ff4b8ac5ffe56b448941627274033eea86a22493aa07682d3" => :high_sierra
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/arduino/arduino-cli").install buildpath.children

    cd "src/github.com/arduino/arduino-cli" do
      system "go", "build", "-o", bin/"arduino-cli"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")
  end
end
