class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.6.0.tar.gz"
  sha256 "90cdd83410d23e32fd47457d227b00cb2c8f607ac38020360eea0e385b693707"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d48acde1c9579c80c89aeabe2475c7c586c28a812dc12d8bd95b4092af31b10c" => :catalina
    sha256 "bbdeb2872cae3e9c27c32c19de382754dd278c44822453d3b06863ff4537ce78" => :mojave
    sha256 "7990eff2bf94ab6970b547977bb8b19c77ddec9216428f8531441b77d191ffad" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "rust"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "#{Dir.pwd}> 2\n#{Dir.pwd}> ", pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')
  end
end
