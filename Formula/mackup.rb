class Mackup < Formula
  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.18.tar.gz"
  sha256 "b4cbc729213717e5343371c682e098518fbd0be2209366a7f1b22c9ba6d1afa4"

  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0b356332ea7bbee9d91f5d68ca902c3452d9de46f614885126d776c496060be1" => :high_sierra
    sha256 "0b356332ea7bbee9d91f5d68ca902c3452d9de46f614885126d776c496060be1" => :sierra
    sha256 "0b356332ea7bbee9d91f5d68ca902c3452d9de46f614885126d776c496060be1" => :el_capitan
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
