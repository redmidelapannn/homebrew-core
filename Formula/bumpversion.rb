class Bumpversion < Formula
  include Language::Python::Virtualenv

  desc "Version-bump your software with a single command"
  homepage "https://pypi.python.org/pypi/bumpversion"
  url "https://files.pythonhosted.org/packages/source/b/bumpversion/bumpversion-0.5.3.tar.gz"
  sha256 "6744c873dd7aafc24453d8b6a1a0d6d109faf63cd0cd19cb78fd46e74932c77e"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d67269aba4020c1adb3b9ccf801f67321e39fd9d4d5dedf3cf0297a4dc73b02" => :high_sierra
    sha256 "5b87fd064b058600e91ac025196755ec983402b2bb3bb99f3c4b5ace9d8012b3" => :sierra
    sha256 "072c68d3a0b7cee907f3c39663c35477475aea5cd66b09b9e83b34bd203381e8" => :el_capitan
  end

  depends_on "python@2"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"VERSION").write "1.2.0"
    system "#{bin}/bumpversion", "patch",
           "--current-version", "1.2.0",
           "--new-version", "1.2.1",
           "VERSION"
    assert_equal "1.2.1", (testpath/"VERSION").read
  end
end
