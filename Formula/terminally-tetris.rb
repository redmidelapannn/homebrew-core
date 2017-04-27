class TerminallyTetris < Formula
  desc "Play Tetris in the Terminal"
  homepage "https://github.com/thecardkid/terminally-tetris"
  url "https://github.com/thecardkid/terminally-tetris/archive/v1.0.0.tar.gz"
  sha256 "213f8a7581e69d3284291187eb887a1c0822fe699d53a7768f0fea777bc1427b"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba8f60970e88bd8ccaaad77d1349b31ec109f82390d22d938c2fe1125c51021c" => :sierra
    sha256 "31d85ecd3882e8b9abef2aa7638025128a5d6070ba99b2a54640932a64c9f713" => :el_capitan
    sha256 "ff57ceb2afdffc4ac4f77cd33daa76cf5691d9cbb052462490b05efd064dcc00" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "make"
    bin.install "build/ttetris"
    man.mkpath
    man1.install "man/ttetris.1"
  end

  test do
    output = shell_output(bin/"ttetris help")
    assert_match "Terminally-Tetris' key bindings", output

    # invalid argument
    output = shell_output(bin/"ttetris save")
    assert_match "Did not recognize argument. See man page for help.", output
  end
end
