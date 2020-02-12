class AwscliSsmPlugin < Formula
  include Language::Python::Virtualenv

  desc "Session Manager plugin for Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/systems-manager/"
  url "https://s3.amazonaws.com/session-manager-downloads/plugin/1.1.54.0/mac/sessionmanager-bundle.zip"
  version "1.1.54.0"
  sha256 "d9b558193370b2ecc0ddba001b6ee974b14b60d4d247851706e26a9811f15349"

  bottle do
    cellar :any_skip_relocation
    sha256 "e84cfa85a52ea76cb14b2b3330d00a6deae6198155b3feffbdec7cf9fcc465a0" => :catalina
    sha256 "0d4fbc1b7d22c0f018f15fc944fc04a3dbed094d1fe592b9409d06cf01effe26" => :mojave
    sha256 "d6ad3aa98c84f5367ffc7b55a542b26905b5d428eec4da496992e7594a7d1c6d" => :high_sierra
  end

  depends_on "awscli"

  def install
    virtualenv_create(libexec, "python3")
    system libexec/"bin/python3 #{buildpath}/install -i #{prefix}"
  end

  test do
    assert_match "The Session Manager plugin was installed successfully. Use the AWS CLI to start a session.", shell_output("#{bin}/session-manager-plugin")
  end
end
