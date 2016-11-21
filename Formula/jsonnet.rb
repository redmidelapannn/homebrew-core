class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data."
  homepage "https://google.github.io/jsonnet/doc/"
  url "https://github.com/google/jsonnet/archive/v0.9.0.tar.gz"
  sha256 "8e1473cc5225b99d626cba44b85177e34bf458112df164d8a6ecc9475608795d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6106e52981eb8abcd1879a8b8ccfa98324677a79749c0ec52eac20fd73af4e0c" => :sierra
    sha256 "12df3db258bb28bdb9f11ad0d5d60a79a023ea90887d8aba7a9b8df9e80259e3" => :el_capitan
    sha256 "280ec1eb4285349ccac079182819ba42c28548c96c9e79769915a701a4dac54f" => :yosemite
  end

  needs :cxx11

  depends_on :macos => :mavericks

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
  end

  test do
    (testpath/"example.jsonnet").write <<-EOS
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
