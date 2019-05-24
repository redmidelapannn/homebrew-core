class Ydcv < Formula
  include Language::Python::Virtualenv

  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://github.com/felixonmars/ydcv/archive/0.7.tar.gz"
  sha256 "03dd5de36ea8fce3170e678e63fc3694e2718b22bc5e1526e3e07f5c36ec9aa0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a30fb60520b3efc1a17d0bbc3ed82afde2a474d930839b75f143efca51e5e78" => :mojave
    sha256 "fd91a0ec88de85f75fc8cd103e8df66ee3691b3abf660be17922cba635c6bae3" => :high_sierra
    sha256 "6aafe5853bdecdb74f58e6bef00f4d6cab10dca9e2087f49cde64014aba91613" => :sierra
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
