class JujuQuickstart < Formula
  desc "Opinionated command-line tool for quickly starting Juju"
  homepage "https://launchpad.net/juju-quickstart"
  url "https://files.pythonhosted.org/packages/source/j/juju-quickstart/juju-quickstart-2.2.4.tar.gz"
  sha256 "fb01c8b48fe8b1e5d75ad3bc29527e78f5b4aadbe464b96e06ba15662a1edaac"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "16d91c64dec87bd563a426f00660bde0cdfd570c660d5fe83a3d7eb5f774718b" => :high_sierra
    sha256 "603f2fcff5f71eafd61a1224bfc0a65db0339c61269e67aca62acd95657065fd" => :sierra
    sha256 "15c26f07579d113baec593495e62953736e516c21c0af1735644b7387052ea64" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "juju"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{libexec}"
    bin.install Dir[libexec/"bin/juju-quickstart"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # While a --version test is noted to be a "bad" test it does
    # exercise that most of the packages can be imported, so it is
    # better than nothing.  Can't really test the spinning up of Juju
    # environments on ec2 as part of installation, given that would
    # cost real money.
    system "#{bin}/juju-quickstart", "--version"
  end
end
