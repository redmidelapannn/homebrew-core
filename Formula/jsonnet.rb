class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/v0.11.2.tar.gz"
  sha256 "c7c33f159a9391e90ab646b3b5fd671dab356d8563dc447ee824ecd77f4609f8"
  head "https://github.com/google/jsonnet.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2637ffc68752a9c8dedffa0c91432f8170f85d16c28b1955f5d713e458d78943" => :mojave
    sha256 "458efb9c0720a7f5946f4a7dce6c4066d15c860cd9cb6d56c7f83d298c99de4d" => :high_sierra
    sha256 "21b181bd5a2f2600e153fa94cfbbb5ef56d8092d571fca62c43a43c09c1d0f6a" => :sierra
  end

  depends_on :macos => :mavericks

  needs :cxx11

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
        "name" => "Alice",
        "welcome" => "Hello Alice!",
      },
      "person2" => {
        "name" => "Bob",
        "welcome" => "Hello Bob!",
      },
    }

    output = shell_output("#{bin}/jsonnet #{testpath}/example.jsonnet")
    assert_equal expected_output, JSON.parse(output)
  end
end
