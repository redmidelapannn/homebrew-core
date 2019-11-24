class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/4c/ee/1a4b3298afd01f276e37dbd3f8d5a42478fb049f08f6255ca2742f7aab9f/juju-wait-2.6.4.tar.gz"
  sha256 "c1dd38c2525fc26d1e89739f9a932aebfd2c1e238e96c980f26527522e7111bf"
  revision 1

  bottle do
    cellar :any
    sha256 "057e4e5f27fa24f93e050ec9659adf915dde81d3d3b1f5886d57a202e9666bc9" => :mojave
    sha256 "2e16a508dfc402ffde8a5aebcd951e41adef5a4ff173508c16042b97a3dde6b0" => :high_sierra
  end

  depends_on "juju"
  depends_on "libyaml"
  depends_on "python"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
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
