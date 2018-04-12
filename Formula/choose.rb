class Choose < Formula
  desc "Make choices on the command-line"
  homepage "https://github.com/geier/choose"
  url "https://github.com/geier/choose/archive/v0.1.0.tar.gz"
  sha256 "d09a679920480e66bff36c76dd4d33e8ad739a53eace505d01051c114a829633"

  head "https://github.com/geier/choose.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "97cf8d937cfa6cec6e997428291a9db85b2c54a26d754c4f3443b87d469cfd39" => :high_sierra
    sha256 "b5d3ca9b415971152d747f257f54d1eda7f3339ebd0903aac12c200e75444437" => :sierra
    sha256 "a4dc328693ed87ef21175c3b045f601739f51bfd8bac2666f7c8c078120dd2b4" => :el_capitan
  end

  depends_on "python@2"

  conflicts_with "choose-gui", :because => "both install a `choose` binary"

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
