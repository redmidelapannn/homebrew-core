class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.0.7.tar.gz"
  sha256 "037c06e2c9058ea8d63886645f8a3b40f45309dc45d301248fa297f48e04028b"
  head "https://github.com/aws/aws-cli.git", :branch => "v2"

  bottle do
    sha256 "391d05dafa5dddec0adbbfcdb31a0b35926885f0d77371070952592d5b6fabc9" => :catalina
    sha256 "c54be383061c128a95951bc9e37c54c01ff699005a197ed0fdd512534dbcebc4" => :mojave
    sha256 "48f880aa4f57d13c043744833793084d0877425220f52eb576f4bc49c9df9378" => :high_sierra
  end

  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
  depends_on "python@3.8"

  uses_from_macos "groff"
  uses_from_macos "libyaml"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "-r", "requirements.txt",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awscli"
    venv.pip_install_and_link buildpath
    pkgshare.install "awscli/examples"

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~EOS
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
  end

  def caveats
    <<~EOS
      The "examples" directory has been installed to:
        #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
