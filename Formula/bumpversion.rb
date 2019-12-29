class Bumpversion < Formula
  include Language::Python::Virtualenv

  desc "Increase version numbers with SemVer terms"
  homepage "https://pypi.python.org/pypi/bumpversion"
  # maintained fork for the project
  # Ongoing maintenance discussion for the project, https://github.com/c4urself/bump2version/issues/86
  url "https://github.com/c4urself/bump2version/archive/v0.5.11.tar.gz"
  sha256 "f06c943b320033b3aa07958c99920474a54f1d0d76b12299fa67d59cdb17ab00"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "e47edd6f548ce7baff73cce57146a61479edfcad8c4dd618a5faf9986fb1a29d" => :catalina
    sha256 "f8d483ce02c2b903dbd84cc641beaaddab332b2d215be6c770171cbce4c1915d" => :mojave
    sha256 "03f4db12a4750ce1bad37695fb98d9c32ce4f23f7d7dcb054ca8e265e04066a0" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_includes shell_output("script -q /dev/null #{bin}/bumpversion --help"), "bumpversion: v#{version}"
    version_file = testpath/"VERSION"
    version_file.write "0.0.0"
    system bin/"bumpversion", "--current-version", "0.0.0", "minor", version_file
    assert_match "0.1.0", version_file.read
    system bin/"bumpversion", "--current-version", "0.1.0", "patch", version_file
    assert_match "0.1.1", version_file.read
    system bin/"bumpversion", "--current-version", "0.1.1", "major", version_file
    assert_match "1.0.0", version_file.read
  end
end
