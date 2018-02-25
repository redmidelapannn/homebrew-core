class Choose < Formula
  desc "Make choices on the command-line"
  homepage "https://github.com/geier/choose"
  url "https://github.com/geier/choose/archive/v0.1.0.tar.gz"
  sha256 "d09a679920480e66bff36c76dd4d33e8ad739a53eace505d01051c114a829633"

  head "https://github.com/geier/choose.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "2ec4e3158a8f7876cd9de26d21d09452d626c3cf5655ec0e0698ed2d706ef80f" => :high_sierra
    sha256 "c200af5f1c0eba278e39466cee5f4ee2c0bfd8c1caf10591ca9027f494d04e20" => :sierra
    sha256 "7da2e4eb1955f3212774762f227f3553f64b8dda92920860cca80ebcee931052" => :el_capitan
  end

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
