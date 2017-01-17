class Aactivator < Formula
  include Language::Python::Virtualenv

  desc "Automatically source and unsource a project's environment"
  homepage "https://github.com/Yelp/aactivator"
  url "https://github.com/Yelp/aactivator/archive/v1.0.0.tar.gz"
  sha256 "395430f9dbabd2644a030d534761899165e2d5c8cb5aa71bf620808543cdfb02"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ea513df5538b0cef53b212392ae6dd182f88f61d4a42c53773304ee24a66f1d" => :sierra
    sha256 "34705b90d1862b621c4bcbbcf52b5e563a3bc656b5b21c80a275a53a92134f93" => :el_capitan
    sha256 "80797b7cf75f3bbf72dbe6962c26d9a5e9d05ab0e70f56ec1a1c48035a98f2c0" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    virtualenv_install_with_resources
  end

  def caveats; <<-EOS.undent
    To add aactivator to your shell, add the following line to your .bashrc or .zshrc:

       eval "$(aactivator init)"

    More information: https://github.com/Yelp/aactivator
    EOS
  end

  test do
    assert_match "aactivator", shell_output("#{bin}/aactivator -h")
  end
end
