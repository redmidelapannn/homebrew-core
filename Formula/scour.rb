class Scour < Formula
  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://github.com/scour-project/scour/archive/v0.34.tar.gz"
  sha256 "5bf12de7acab8958531fc6b84641bbb656cc85b1517d7b28bcfa54eb84f133be"
  head "https://github.com/scour-project/scour.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "6acc489cd075f12ba19791533f27dd1a50c50a91c123ed2491d87381fe82b72b" => :el_capitan
    sha256 "7a78f70cf50e930d6d84714f04c0895444f6bbeeeed805b1842e6bb560aebfe2" => :yosemite
    sha256 "f3060b73cad9c236c80c876c983768fa5dfd69d2483ae6a9869eb515dcc4b16b" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("six").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert File.exist? "scrubbed.svg"
  end
end
