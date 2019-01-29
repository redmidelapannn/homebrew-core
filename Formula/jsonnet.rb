class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/v0.12.1.tar.gz"
  sha256 "257c6de988f746cc90486d9d0fbd49826832b7a2f0dbdb60a515cc8a2596c950"
  head "https://github.com/google/jsonnet.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e94136d25ffd0ffa60f3ef35a6c4ec3d010fc72ce9cf4bda5520f81856af901e" => :mojave
    sha256 "b4df3b85f9f83d729dd850b7fe5b5a89fd117e1cbcfbdbca04dbd7b386ead36f" => :high_sierra
    sha256 "9f5e06a2812ba19040e4c5c4dd241a3ea78e48372052ad7e9232c536a93c64d3" => :sierra
  end

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
  end

  test do
    (testpath/"example.jsonnet").write <<~EOS
      {
        person1: {
          name: "Alice",
          welcome: "Hello " + self.name + "!",
        },
        person2: self.person1 { name: "Bob" },
      }
    EOS

    expected_output = {
      "person1" => {
        "name"    => "Alice",
        "welcome" => "Hello Alice!",
      },
      "person2" => {
        "name"    => "Bob",
        "welcome" => "Hello Bob!",
      },
    }

    output = shell_output("#{bin}/jsonnet #{testpath}/example.jsonnet")
    assert_equal expected_output, JSON.parse(output)
  end
end
