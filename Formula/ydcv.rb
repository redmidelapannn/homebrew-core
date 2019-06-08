class Ydcv < Formula
  include Language::Python::Virtualenv

  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://github.com/felixonmars/ydcv/archive/0.7.tar.gz"
  sha256 "03dd5de36ea8fce3170e678e63fc3694e2718b22bc5e1526e3e07f5c36ec9aa0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c5192fa59ec3f6359dc05bc21ffe7aba403b8d69e506b2f846afc25a33a71d1" => :mojave
    sha256 "8c4430e876da12bb1ee23d5d99f8874754c738a8cf37d920f4b049cb5291ee8e" => :high_sierra
    sha256 "4d67d6bd069f02a6df5afd59ecf0e49b788c260e4cd6e92413f47eb276b22673" => :sierra
  end

  depends_on "python"

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version

    zsh_completion.install "contrib/zsh_completion" => "_ydcv"
    virtualenv_install_with_resources
  end

  test do
    assert_match "hello", shell_output("#{bin}/ydcv 你好")
    assert_match "你好", shell_output("#{bin}/ydcv hello")
  end
end
