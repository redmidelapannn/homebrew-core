class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your application settings in sync (OS X/Linux)"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.26.tar.gz"
  sha256 "e74d8cfd235a70dea26f0f3fcf4f60a78313e51c1a01ae3edd2558bf5c62dd7a"
  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cacd32c97782a14580e9027edc9c5ec313742d00f88bfd1ce5248a677ef46dc7" => :mojave
    sha256 "a977b8a6ad41138ce77dcc1eaf73fde8ad70d58f4941b7901fbe7f2bd838991a" => :high_sierra
    sha256 "1bd5a8c845abbc96e415eca81185471b48abd6f1543c7e6f2b030c87ed0b13af" => :sierra
  end

  depends_on "python"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end
