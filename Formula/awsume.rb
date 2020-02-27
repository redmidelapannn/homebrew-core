class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://awsu.me"
  url "https://github.com/trek10inc/awsume/archive/4.1.10.tar.gz"
  sha256 "962b4f7ce25c4647fdc5c286a78cc8a1bf65d75e799116084b4b362a63ef7eb2"
  head "https://github.com/trek10inc/awsume.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d0cfc844273390c366280905ac21dcb2f7cf0b05aa10e42f180ec07d238516d4" => :catalina
    sha256 "f2e8a9127c0f7e2711f42bbe8b77de758140bdbe055fd116b1a8a4378488addb" => :mojave
    sha256 "6aba0826a2c85cef27fc4fa364780fe4e0bfec73bdc1d957665c42b0ebc1ee63" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "python"
  uses_from_macos "sqlite"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awsume"
    venv.pip_install_and_link buildpath
  end

  def caveats
    <<~EOS
      In order for Awsume to work correctly, you will need to add the follwoing to your bash_profile or similar.

      alias aswume=". awsume"
    EOS
  end

  test do
    assert_includes "4.0.0", shell_output("#{bin}/awsume -v")

    file_path = File.expand_path("~/.awsume/config.yaml")
    shell_output(File.exist?(file_path))

    assert_match "PROFILE  TYPE  SOURCE  MFA?  REGION  ACCOUNT", shell_output("#{bin}/awsume --list-profiles 2>&1")
  end
end
