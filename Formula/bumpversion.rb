class Bumpversion < Formula
  include Language::Python::Virtualenv

  desc "Increase version numbers with SemVer terms"
  homepage "https://pypi.python.org/pypi/bumpversion"
  # maintained fork for the project
  # Ongoing maintenance discussion for the project, https://github.com/c4urself/bump2version/issues/86
  url "https://github.com/c4urself/bump2version/archive/v1.0.0.tar.gz"
  sha256 "06a7cb0fb7155b9283c4d10180e477f658754595b4dedb249f1e143e899d0e6c"

  bottle do
    cellar :any_skip_relocation
    sha256 "d92f22041c0a20af67c53c63d6a5ed6ea7ef190898a8a4512d5a2584338a45ee" => :catalina
    sha256 "e731c6a189faa3065552cd5bddd24be3726235f5b16668ddf5d2c97ccd4a44c4" => :mojave
    sha256 "62b2870dd8d0d21e98c4888f8d166b55c787925cf6fa7ee32228585d0e53a82c" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["COLUMNS"] = "80"
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
