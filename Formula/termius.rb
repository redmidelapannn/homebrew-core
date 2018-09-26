class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.11.tar.gz"
  sha256 "cc8553c9786274de828fc2fc71509e525ef1d8befebb0c74728de59f721912d6"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "master"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ffd5c4aeab7b3997f8639e9d8a32a813afbdc1e8c2d66584f9678612028212ae" => :mojave
    sha256 "c61b6f5c9d8ab91e839c5b547f384f11cb520348261de0899f1b14bc4cd60790" => :high_sierra
    sha256 "fb747b740052f5b05118130fd584c811b6cc927faf89ee13156599cef7012697" => :sierra
  end

  depends_on "bash-completion"
  depends_on "openssl"
  depends_on "python@2"
  depends_on "zsh-completions"

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "termius"
    venv.pip_install_and_link buildpath

    bash_completion.install "contrib/completion/bash/termius"
    zsh_completion.install "contrib/completion/zsh/_termius"
  end

  test do
    system "#{bin}/termius", "host", "--address", "localhost", "-L", "test_host"
    system "#{bin}/termius", "host", "--delete", "test_host"
  end
end
