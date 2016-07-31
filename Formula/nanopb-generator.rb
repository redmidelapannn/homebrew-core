class NanopbGenerator < Formula
  desc "ANSI C library for encoding and decoding Protocol Buffer messages"
  homepage "https://koti.kapsi.fi/jpa/nanopb/docs/index.html"
  url "https://koti.kapsi.fi/~jpa/nanopb/download/nanopb-0.3.5.tar.gz"
  sha256 "3dd539671403d578425f15c6b4b6ba7390ee9a20369b969637ef1d18487e150e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "23ac4ba4b308e8cec5575c13272ece54744dfea0987b6ebf0c24983d3f453ff9" => :el_capitan
    sha256 "de4e0fc7f723dc65cbb141630e9c5f97b3a52ff0be40171c868f05c40aeb9aa9" => :yosemite
    sha256 "86e32245b3bc32aed6ef3c5d34a0fda93346e90816417597ff5c2054dac5a8ba" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "protobuf"

  resource "protobuf-python" do
    url "https://pypi.python.org/packages/source/p/protobuf/protobuf-2.6.0.tar.gz"
    sha256 "b1556c5e9cca9069143b41312fd45d0d4785ca0cab682b2624195a6bc4ec296f"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    resource("protobuf-python").stage do
      system "python", "setup.py", "install", "--prefix=#{libexec}"
    end

    Dir.chdir "generator"

    system "make", "-C", "proto"

    libexec.install "nanopb_generator.py", "protoc-gen-nanopb", "proto"

    (bin/"protoc-gen-nanopb").write_env_script libexec/"protoc-gen-nanopb", :PYTHONPATH => ENV["PYTHONPATH"]
    (bin/"nanopb_generator").write_env_script libexec/"nanopb_generator.py", :PYTHONPATH => ENV["PYTHONPATH"]
  end

  test do
    (testpath/"test.proto").write <<-PROTO.undent
      message Test {
        required string test_field = 1;
      }
    PROTO
    system Formula["protobuf"].bin/"protoc",
      "--proto_path=#{testpath}", "--plugin=#{bin}/protoc-gen-nanopb",
      "--nanopb_out=#{testpath}", testpath/"test.proto"
    system "grep", "test_field", testpath/"test.pb.c"
    system "grep", "test_field", testpath/"test.pb.h"
  end
end
