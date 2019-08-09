class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://github.com/starship/starship"
  url "https://github.com/starship/starship/archive/v0.5.0.tar.gz"
  sha256 "f4b611d757b6cf54ee9250a0d672453e090d0453a6e6edf96ccd740e7b607692"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d9db895cd1217725b60746ed7fd99e3e71d70dfdb872ef8f95da5bde38b894c9" => :mojave
    sha256 "ecfa93b18174466e73934de871b5a7b9d4fcc54a190fb41cd7dc624162e8617d" => :high_sierra
    sha256 "41c0d3a8dce9cf1923abc26491890ac10b33784590f482a93acf1cc50d7e8182" => :sierra
  end

  depends_on "rust" => :build
  depends_on "openssl"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  def caveats; <<~EOS
    Please follow the steps for your shell to complete the installation:

    - Bash / Zsh
      Add the following to the end of ~/.bashrc or ~/.zshrc:

        eval "$(starship init $0)"

    - Fish
      Add the following to the end of  ~/.config/fish/config.fish:

        eval (starship init fish)
  EOS
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m➜[0m ", shell_output("#{bin}/starship module char")
  end
end
