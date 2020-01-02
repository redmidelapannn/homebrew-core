class Upterm < Formula
  desc "Secure terminal sharing"
  homepage "https://upterm.dev"
  url "https://github.com/jingweno/upterm/archive/v0.0.5.tar.gz"
  sha256 "76b45f8124fdf6f04e118543f39f6532482be0f5087a3c8d36bfd688902560ee"
  head "https://github.com/jingweno/upterm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0639f6ef8b2283368343ad222968abc61f9ec892465e620bbf26dda89e148fe7" => :catalina
    sha256 "21a396f1785084778bb2b802dbecf2cad38a6dd54eeb1e1a2cf8893221e31c1f" => :mojave
    sha256 "50bb864a770044c3a50a88464f2b7ed9993003d4fa13d71f398e056485386f31" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "build/upterm"

    prefix.install_metafiles

    bash_completion.install "etc/completion/upterm.bash_completion.sh"
    zsh_completion.install "etc/completion/upterm.zsh_completion" => "_upterm"

    man.install "etc/man/man1"
  end

  test do
    assert_match(/upterm version 0.0.5/, shell_output("#{bin}/upterm version"))
  end
end
