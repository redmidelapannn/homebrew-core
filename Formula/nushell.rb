class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.6.1.tar.gz"
  sha256 "3f7878df7d77fe330e6840428845800d9eefc2ad8248617c42004030ecf527f0"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b039171f841f6810116b88aaaefd55441fd81e2fa784b0ce683d90ca92da6086" => :catalina
    sha256 "a9cadb8944b89d023f7b5721bdfb68ad750a0d456af5932ff146f3769184d744" => :mojave
    sha256 "07268c955cc7ed076468dc1a9f3e8064cd11bf579dfd46acd3d3f0c084ebcf24" => :high_sierra
  end

  depends_on "rust" => :build

  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "#{Dir.pwd}> 2\n#{Dir.pwd}> ", pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')
  end
end
