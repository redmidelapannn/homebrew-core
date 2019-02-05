class Ilogyou < Formula
  desc "Swift Framework for membership handling"
  homepage "https://github.com/leolgrn/iLogYou/"
  url "https://github.com/leolgrn/iLogYou/releases/download/iLogYou/iLogYou.tar.gz"
  version "1.0.0"
  sha256 "3f12b57f7cadd25666ca528ab4f8cfd60fbeb51b6d2b0c0a69037e990aeee5f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff0193a7274cd06c145d9ab5936f16710044fd2fd570be02ac3979720ae5683f" => :mojave
    sha256 "ff0193a7274cd06c145d9ab5936f16710044fd2fd570be02ac3979720ae5683f" => :high_sierra
    sha256 "20b3291d2fa925c95f176165ab745f7d2716fca7967bf6d5d3247088795a5cc0" => :sierra
  end

  def install
    bin.install "iLogYou"
  end

  test do
    system "false"
  end
end
