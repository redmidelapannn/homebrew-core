class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/3d/c2/8cce9ec8386be418a76566fcd2e7dcbaa7138a92b0b9b463306d9191cfd7/juju-wait-2.6.2.tar.gz"
  sha256 "86622804896e80f26a3ed15dff979584952ba484ccb5258d8bab6589e26dd46d"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "d7ad68375902092531607ebab91f43adee65a7c1a9fd465e12da091762d580db" => :high_sierra
    sha256 "5521f238606e1d27a490a63950116a7384a59771244878db7d46144666b0656c" => :sierra
    sha256 "62ecf2f99833022e0239edeaa28dac0f9260eccf187ba1ef320e902621a93ae3" => :el_capitan
  end

  depends_on "python3"
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
