class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli/archive/0.3.4-alpha.preview.tar.gz"
  version "0.3.4-alpha"
  sha256 "5ef20b59f27dc8ebeb6e3c6cd854ce3dd79fe2900189ea9bd8b4272ef83defb4"

  bottle do
    cellar :any_skip_relocation
    sha256 "a143197740bef61d05e670318608b97e2d8aa1aa94b877357e03ddb841ddd9f9" => :mojave
    sha256 "e7ef94e88dd552e105adc1ef3012633b3fb94c4658d21b7dce237663142b33ce" => :high_sierra
    sha256 "5acd679c599c9783c27608e027a5d7d69667c8dc4d0e790db23271f763dd6f49" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/arduino/arduino-cli").install buildpath.children

    cd "src/github.com/arduino/arduino-cli" do
      system "go", "build", "-o", bin/"arduino-cli"
      prefix.install_metafiles
    end
  end

  test do
    config = File.open("#{bin}/.cli-config.yml", "w")
    config.write <<~EOS
    - paths:
      - sketchbook_path: #{testpath}
    EOS
    system "#{bin}/arduino-cli sketch new --debug TestSketch"
    code = File.open(testpath"/TestSketch/TestSketch.ino", "rb")
    assert_equal "void setup() {
}

void loop() {
}
", code
  end
end
