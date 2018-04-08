class JujuQuickstart < Formula
  desc "Opinionated command-line tool for quickly starting Juju"
  homepage "https://launchpad.net/juju-quickstart"
  url "https://files.pythonhosted.org/packages/source/j/juju-quickstart/juju-quickstart-2.2.4.tar.gz"
  sha256 "fb01c8b48fe8b1e5d75ad3bc29527e78f5b4aadbe464b96e06ba15662a1edaac"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fc918393a29db3a410b126da1c1e35988057ffafa0e656bb64bcca86bbc15135" => :high_sierra
    sha256 "877505a28f98f05e875cb184c3201fd63c1e36739bbb3d5eb71aeac237c92112" => :sierra
    sha256 "1970e91895f96772a12d9859f55b04c91fe2f04869fa1dc0a8e9dd2ef11b86bf" => :el_capitan
  end

  depends_on "python@2"
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
