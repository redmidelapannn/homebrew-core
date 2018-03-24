class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/3d/c2/8cce9ec8386be418a76566fcd2e7dcbaa7138a92b0b9b463306d9191cfd7/juju-wait-2.6.2.tar.gz"
  sha256 "86622804896e80f26a3ed15dff979584952ba484ccb5258d8bab6589e26dd46d"
  revision 3

  bottle do
    cellar :any
    rebuild 1
    sha256 "de15b0b27e37f3a06a568579d3b2265a5e7124965c360e506c0b3e3314ba771f" => :high_sierra
    sha256 "205c1286642ee604a35a7dea2b43c3e29ae91e262879f62059ac578c6e2116cb" => :sierra
    sha256 "6526ed27171662d37697cb99828ed4cf73c86500c406e6c95accf7468fb6a2e2" => :el_capitan
  end

  depends_on "python"
  depends_on "libyaml"
  depends_on "juju"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Note: Testing this plugin requires a Juju environment that's in the
    # process of deploying big software. This plugin relies on those application
    # statuses to determine if an environment is completely deployed or not.
    system "#{bin}/juju-wait", "--version"
  end
end
