class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://github.com/scour-project/scour/archive/v0.36.tar.gz"
  sha256 "1b6820430c671c71406bf79afced676699d03bd3fcc65f01a651da5dcbcf3d3b"
  head "https://github.com/scour-project/scour.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "58b8094856f8ee4a5a53134c44ba5218cf435c1b969ea315f8e510ee3fcdfc04" => :high_sierra
    sha256 "85c0db328d5537e62eae92d3d0d9460bc8cd5d9c36d7b6615b691fce38d9f057" => :sierra
    sha256 "48da8a17c117f69ced6d2b5fb16ab58732f01d0883599d36909497d9886ca428" => :el_capitan
  end

  depends_on "python@2"

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert_predicate testpath/"scrubbed.svg", :exist?
  end
end
