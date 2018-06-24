class Bashate < Formula
  include Language::Python::Virtualenv

  desc "Code style enforcement for bash programs"
  homepage "https://github.com/openstack-dev/bashate"
  url "https://github.com/openstack-dev/bashate/archive/0.5.1.tar.gz"
  sha256 "44fa6645fd7d5169c40747714986f1093ed24e2474e4a368c2695bf339c1551e"

  bottle do
    cellar :any_skip_relocation
    sha256 "7df8dca71ee644938cffd3ab84e2b4a3e770cc86738469becb5ac5cc5406de41" => :high_sierra
    sha256 "39a820d9e368b931b4b8c78c3c8b09d33fdff0f0e8e38e76203398583e68997c" => :sierra
    sha256 "6114e0029af47ee5e68c216f2af560ba2d7f64d5fb5ba6db1a886061e2619618" => :el_capitan
  end

  depends_on "python@2"

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/source/p/pbr/pbr-4.0.4.tar.gz"
    sha256 "a9c27eb8f0e24e786e544b2dbaedb729c9d8546342b5a6818d8eda098ad4340d"
  end

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install resources
    # Needed to set version for Bashate, but only after pbr has been installed
    # otherwise we end up overriding that's versions as well and that's bad
    ENV.append("PBR_VERSION", "0.5.1")
    venv.pip_install_and_link buildpath
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/bin/bash
      echo "Testing Bashate"
    EOS
    system "#{bin}/bashate", testpath/"test.sh"
  end
end
