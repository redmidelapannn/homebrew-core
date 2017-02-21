class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.51.tar.gz"
  sha256 "6d1c1e99dcecbb81cd527984fab41ef42a43bf081f9922bfd8ccc97e45049a32"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4d211d955ab8dbbf7ae616c93d117d30a819611a23327f101146785c578d9f1a" => :sierra
    sha256 "d0c4f1d54851ceb901b459d206981db97914d17ef26daa58fb6e92794e1ee497" => :el_capitan
    sha256 "e5ad2d5899d7fee0ea4af7eca7a4d27c70b7738c5e49a1813f1854e997dc668b" => :yosemite
  end

  # Use :python on Lion to avoid urllib3 warning
  # https://github.com/Homebrew/homebrew/pull/37240
  depends_on :python if MacOS.version <= :lion

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awscli"
    venv.pip_install_and_link buildpath
    pkgshare.install "awscli/examples"

    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh" => "_aws"
  end

  def caveats; <<-EOS.undent
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
