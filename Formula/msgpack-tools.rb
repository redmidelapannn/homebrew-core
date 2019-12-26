class MsgpackTools < Formula
  desc "Command-line tools for converting between MessagePack and JSON"
  homepage "https://github.com/ludocode/msgpack-tools"
  url "https://github.com/ludocode/msgpack-tools/releases/download/v0.6/msgpack-tools-0.6.tar.gz"
  sha256 "98c8b789dced626b5b48261b047e2124d256e5b5d4fbbabdafe533c0bd712834"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d7b5c20f5421b0fbe5b892b5fd182bcdd22d944d76f68d5a82652b56479ba15b" => :catalina
    sha256 "4d5e9584e2ec03aa1a43b95982605390de00ada8d4a65f44630fee301939b127" => :mojave
    sha256 "bb07837420f328c9fa40eda311af7ae60536ae9ae6d4b7fe6e43a4be503c4448" => :high_sierra
  end

  depends_on "cmake" => :build

  conflicts_with "remarshal", :because => "both install 'json2msgpack' binary"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install", "PREFIX=#{prefix}/"
  end

  test do
    json_data = '{"hello":"world"}'
    assert_equal json_data,
      pipe_output("#{bin}/json2msgpack | #{bin}/msgpack2json", json_data, 0)
  end
end
