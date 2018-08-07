class Choose < Formula
  desc "Make choices on the command-line"
  homepage "https://github.com/geier/choose"
  url "https://github.com/geier/choose/archive/v0.1.0.tar.gz"
  sha256 "d09a679920480e66bff36c76dd4d33e8ad739a53eace505d01051c114a829633"
  head "https://github.com/geier/choose.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "40341a9ab7c46b2e5f78a96b4ea27b7396786204d503463b317b561b14ec1e56" => :high_sierra
    sha256 "74b030467bfe9b907ec13ad192adae8dc9c1d86580494c968070da3a2685fa37" => :sierra
    sha256 "c1dedee1a314471178dde16a1e047016829fd874d26daa7e28d53ca50d031b7e" => :el_capitan
  end

  depends_on "python@2"

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/source/u/urwid/urwid-1.2.1.tar.gz"
    sha256 "9b9b5dabb7df6c0f12e84feed488f9a9ddd5c2d66d1b7c7c087055720b87c68c"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    resource("urwid").stage do
      system "python", *Language::Python.setup_install_args(libexec)
    end

    bin.install "choose"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # There isn't really a better test than that the executable exists
    # and is executable because you can't run it without producing an
    # interactive selection ui.
    assert_predicate bin/"choose", :executable?
  end
end
