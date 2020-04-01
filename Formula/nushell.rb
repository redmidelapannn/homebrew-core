class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.12.0.tar.gz"
  sha256 "f6bd3b36722b2edd7a89b945c3e9d91dcc1c32e472ba82f61816c65b0083cde0"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33ef4db2342807864e5444cb3b946333eaaabcffbcb6cf292619bc5238d922e9" => :catalina
    sha256 "b4410eda976eb4b57b5fb2a8d8df705e25ab865638ba1c934807633d3cebea0f" => :mojave
    sha256 "49b92eef381b4a203d4c7e05b920c693dadfe17a682d75391aa5d898151b5dc9" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--features", "stable", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_equal pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it'),
    "Welcome to Nushell #{version} (type 'help' for more info)\n~ \n❯ 2~ \n❯ "
  end
end
