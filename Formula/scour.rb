class Scour < Formula
  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://github.com/codedread/scour/archive/v0.33.tar.gz"
  sha256 "e9b4fb4beb653afbdbc43c4cc0836902d6f287d882b6b7cdf714c456ff0841a8"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "cfe6611e285a67ebf5b4c0ea8d7a3ae8da1c69fd7b9f5c6792d84132fd6f7a52" => :el_capitan
    sha256 "9c7fefce72e31b27d4d9640df6fa8119a431eea402158e7bb5a3139d69a88cac" => :yosemite
    sha256 "9d45a453c8bf1209229de9d5f3c51c711879f3cd072bef640267da7e59e4164c" => :mavericks
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
