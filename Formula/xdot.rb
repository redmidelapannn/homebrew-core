class Xdot < Formula
  desc "Interactive viewer for graphs written in Graphviz's dot language."
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/8e/d5/2fadb9ba06cd46728183d5c788557a6cb7f9a0686a9c1a953e31c9b7e745/xdot-0.8.tar.gz"
  sha256 "7cafed00bae21ecda6acef9c598d8297d7d70b2f8d8050d45f6bd0e44c646933"
  head "https://github.com/jrfonseca/xdot.py.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b3eb09133fb7483cafbbc492459dcf9ed08e22832db43a85a2f1ee700f5c372" => :sierra
    sha256 "9b3eb09133fb7483cafbbc492459dcf9ed08e22832db43a85a2f1ee700f5c372" => :el_capitan
    sha256 "9b3eb09133fb7483cafbbc492459dcf9ed08e22832db43a85a2f1ee700f5c372" => :yosemite
  end

  depends_on "pygobject3"
  depends_on "pygtk"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/xdot", "--help"
  end
end
