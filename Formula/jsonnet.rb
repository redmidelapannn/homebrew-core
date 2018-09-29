class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/v0.11.2.tar.gz"
  sha256 "c7c33f159a9391e90ab646b3b5fd671dab356d8563dc447ee824ecd77f4609f8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "616b0928d52fb55a897d79c0fc7f7d4384061a6427490b8a927da7e25dce7f51" => :mojave
    sha256 "24b5124167c65453dceae965a6cd2c160fc0b835b67218cd3db634a3f55d63c4" => :high_sierra
    sha256 "6b88c02ca534ae906f40f85700b1148573bb4bb034e2700d787f0dc8cf0dcab1" => :sierra
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
