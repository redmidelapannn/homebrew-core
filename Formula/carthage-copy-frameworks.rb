class CarthageCopyFrameworks < Formula
  include Language::Python::Virtualenv

  desc "Helper to sign and bundle frameworks built by Carthage"
  homepage "https://github.com/lvillani/carthage-copy-frameworks"
  url "https://github.com/lvillani/carthage-copy-frameworks/archive/v1.2.0.tar.gz"
  sha256 "15835dffff329aa931209d184fd43a831a894594b80c2a52843e1f5f25fe2e7f"
  head "https://github.com/lvillani/carthage-copy-frameworks.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "12495a7547556fa468a24d092ec033bf5c289eb92f539d9a969ce068717f219d" => :high_sierra
    sha256 "dd2f0487fba351734be9541799a963d6af44074ff29d8ed5df1495944aa36392" => :sierra
    sha256 "6b6dcc2346f046dbb05aceeb1c18d3f1fb2daea2de4e6222f0751563f09b58dd" => :el_capitan
  end

  def install
    virtualenv_install_with_resources
  end
end
