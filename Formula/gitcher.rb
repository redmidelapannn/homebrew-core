class Gitcher < Formula
  include Language::Python::Virtualenv

  desc "The git profile switcher."
  homepage "https://gitlab.com/GlezSeoane/gitcher"
  url "https://gitlab.com/GlezSeoane/gitcher/-/archive/v2.0/gitcher-v2.0.tar.gz"
  sha256 "0c649235c78e0698fb062b758a12c9c74722eba2db484983fb85f080dbaa29b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "f99448459f6b71ca749e0c848975a8f6e2ba1c8ff11afcaa4302d9cab60497b3" => :mojave
    sha256 "c4c516f4e55204fc560bdbd0cfbac29d1d5fe4b7ab5a4568cbbf90b7b7f71f79" => :high_sierra
    sha256 "b68fcefc502963fcb9fc9b8541e4d18bb3ccc818a29c15dccbe0662cf3b9fea0" => :sierra
  end

  depends_on "python"

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/e0/a1/36203205f77ccf98f3c6cf17cf068c972e6458d7e58509ca66da949ca347/prettytable-0.7.2.tar.gz#sha256=2d5460dc9db74a32bcc8f9f67de68b2c4f4d2f01fa3bd518764c69156d9cacd9"
    sha256 "2d5460dc9db74a32bcc8f9f67de68b2c4f4d2f01fa3bd518764c69156d9cacd9"
  end
  resource "validate_email" do
    url "https://files.pythonhosted.org/packages/84/a0/cb53fb64b52123513d04f9b913b905f3eb6fda7264e639b4573cc715c29f/validate_email-1.3.tar.gz#sha256=784719dc5f780be319cdd185dc85dd93afebdb6ebb943811bc4c7c5f9c72aeaf"
    sha256 "784719dc5f780be319cdd185dc85dd93afebdb6ebb943811bc4c7c5f9c72aeaf"
  end

  def install
    virtualenv_install_with_resources
    man1.install "manpages/gitcher.1"
  end

  test do
    system "python", "-c", "'import gitcher'"
  end
end
