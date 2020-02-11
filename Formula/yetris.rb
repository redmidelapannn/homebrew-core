class Yetris < Formula
  desc "Customizable Tetris for the terminal"
  homepage "https://github.com/alexdantas/yetris"
  url "https://github.com/alexdantas/yetris/archive/v2.3.0.tar.gz"
  sha256 "720c222325361e855e2dcfec34f8f0ae61dd418867a87f7af03c9a59d723b919"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ef924188045a02e9c11290add57829a1c36c2e081502c9fe43afccc31902fb54" => :catalina
    sha256 "35dc6e9068cfec9f4a4ab56e007fb36f570227cdce75e67e4f8bf865ce969615" => :mojave
    sha256 "f63e2c5bcf6cb652fa04d40b50c3f7c578d6350a2de2ddf5c66666cf9db76572" => :high_sierra
  end

  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/yetris --version")
  end
end
