class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://github.com/pipxproject/pipx"
  url "https://files.pythonhosted.org/packages/b5/42/bdf9b6cc0af79222f69776d931ef79235946095b16594bac1f6bd81f435f/pipx-0.13.0.1.tar.gz"
  sha256 "5134955d0d0595ca8040ecfa4215f2ddb84d34569c118ab2cde84b1d2b240b42"

  bottle do
    cellar :any_skip_relocation
    sha256 "f935b85bb56ffeff1265a35fe14d8b64e435cadc3366b97b5c47f33ac160685f" => :mojave
    sha256 "f935b85bb56ffeff1265a35fe14d8b64e435cadc3366b97b5c47f33ac160685f" => :high_sierra
    sha256 "321cad269edb3106ace49bdd522206e8880b25ce4b668d36c9aa7622cda2992b" => :sierra
  end

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<~EOS
    Run this command to ensure ~/.local/bin is on your PATH:
      pipx ensurepath
  EOS
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
  end
end
