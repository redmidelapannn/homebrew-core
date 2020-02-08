class KnightosSdk < Formula
  include Language::Python::Virtualenv

  desc "The KnightOS SDK"
  homepage "https://KnightOS.org"
  url "https://github.com/KnightOS/sdk/archive/2.0.9.tar.gz"
  sha256 "0fd7d1322aa925e06fa595bf52e4a1d04f7661b975d37bb9b78ff481d8ad63bc"

  depends_on "genkfs"
  depends_on "kpack"
  depends_on "python"
  # depends_on "kimg" => :test
  # depends_on "mktiupgrade" => :test

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end
  resource "pystache" do
    url "https://files.pythonhosted.org/packages/source/p/pystache/pystache-0.5.4.tar.gz"
    sha256 "f7bbc265fb957b4d6c7c042b336563179444ab313fb93a719759111eabd3b85a"
  end
  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/source/P/PyYAML/PyYAML-5.3.tar.gz"
    sha256 "e9f45bd5b92c7974e59bcd2dcc8631a6b6cc380a904725fce7bc08872e691615"
  end
  resource "requests" do
    url "https://files.pythonhosted.org/packages/source/r/requests/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end
  # Requests dependencies
  resource "certifi" do
    url "https://files.pythonhosted.org/packages/source/c/certifi/certifi-2019.11.28.tar.gz"
    sha256 "25b64c7da4cd7479594d035c08c2d809eb4aab3a26e5a990ea98cc450c320f1f"
  end
  resource "chardet" do
    url "https://files.pythonhosted.org/packages/source/c/chardet/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end
  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/source/u/urllib3/urllib3-1.25.8.tar.gz"
    sha256 "87716c2d2a7121198ebcb7ce7cccf6ce5e9ba539041cfbaeecfb641dc0bf6acc"
  end
  resource "idna" do
    url "https://files.pythonhosted.org/packages/source/i/idna/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # TODO: Fix this
    system bin/"knightos", "--help"
    system "false"
  end
end
