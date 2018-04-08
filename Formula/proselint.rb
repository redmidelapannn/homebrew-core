class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "http://proselint.com"
  url "https://files.pythonhosted.org/packages/1b/d2/2e6afa3f933a12bfb1eb588f1ec8c26f915935356d8a0e51b2e5c53bfd04/proselint-0.8.0.tar.gz"
  sha256 "08d48494533f178eb7a978cbdf10ddf85ed7fc2eb486ff5e7d0aecfa08e81bbd"
  head "https://github.com/amperser/proselint.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a5f79d426770e6376ff4c389ab44c0499a9fe13c5a8d99ae0874edc7a7d2811f" => :high_sierra
    sha256 "94b2af9ea237199acec46fd0be3ba4455062ac0ca7a770e23a60e56b1cebb474" => :sierra
    sha256 "234d20f02ec7dc6394b93c284e8e0a14e3915ebee27fbb46be80457f018d100e" => :el_capitan
  end

  depends_on "python@2"

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/proselint --compact -", "John is very unique.")
    assert_match /weasel_words\.very.*uncomparables/m, output
  end
end
