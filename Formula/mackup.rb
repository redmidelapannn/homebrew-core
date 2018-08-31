class Mackup < Formula
  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.19.tar.gz"
  sha256 "28c1318a716acd6e9b3ec6ccf5c8a0087dbeb8c46ccef78d1891479dd4ccf31a"
  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3314003a17c1cab32919e712008e15df7c46c82bd393b5bf66b1eff5bcc22ad4" => :mojave
    sha256 "0a3e6fb011c7f9612c01c0a36adf9bae754547668a7faffb360a140561ff95f6" => :high_sierra
    sha256 "0a3e6fb011c7f9612c01c0a36adf9bae754547668a7faffb360a140561ff95f6" => :sierra
    sha256 "0a3e6fb011c7f9612c01c0a36adf9bae754547668a7faffb360a140561ff95f6" => :el_capitan
  end

  depends_on "python@2"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[docopt].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end
