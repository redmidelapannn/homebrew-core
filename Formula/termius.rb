class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.10.tar.gz"
  sha256 "3018a7c290206ea61ef59936ea01caba58677eacafcab844b01a54c261e17247"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "master"

  bottle do
    cellar :any
    rebuild 1
    sha256 "63ebc8bad87a8eaca78019b394ff45713cfa81221bab1aa7ddc2ec18205af0e9" => :high_sierra
    sha256 "2c641aa3560ea4b719962f5cb0cd0b58e2f297b3a8030dff8c32924ea2218e6c" => :sierra
    sha256 "a3fb54b67cf7ebb5c4e049d12372f0d5fbf7ea37824df1a62a0d98ad13b1b21b" => :el_capitan
  end

  depends_on "python@2"
  depends_on "openssl"
  depends_on "bash-completion" => :recommended
  depends_on "zsh-completions" => :recommended

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
