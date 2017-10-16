class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.171.tar.gz"
  sha256 "06ae8bbfb236aabb147102f4735d8ac59b6267559af4f3cab94b0e6e608d5d4d"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "d32fecc2cde8081bbf51044fe0c170b5b8cd4f35de94c1493e7742dac85fc8cc" => :high_sierra
    sha256 "483df9c04efe7fd078737e82a9b645fd1bf7d3d4f5b7c75dab26cea5533801e5" => :sierra
    sha256 "0d3082d981fd8be535f554cbd9d5ab541a2fa31df0b64874adb03e4ba14e9e95" => :el_capitan
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

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<-EOS.undent
        #compdef aws
        _aws () {
          local e
          e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
          if [[ -f $e ]]; then source $e; fi
        }
    EOS
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
