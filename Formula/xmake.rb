class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.3.1/xmake-v2.3.1.tar.gz"
  sha256 "4b1b46233d84259a66bc112d05513feae2507f1b30b4c2a494c4bdf84e5845dd"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e7298b881ece74b5e9e8f752d7f0cf948cd69d08c55439ca32165b77d83e238b" => :catalina
    sha256 "77ca4e0ba85264065b22b82b39f8a0b9d36d17e29b71fc3bdd5f63a1e30a310f" => :mojave
    sha256 "790ca7bfc7ba1396b4cdbc3c1789f390097d63c176503c8403c76a5d489ac33e" => :high_sierra
  end

  def install
    system "make", "build"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
