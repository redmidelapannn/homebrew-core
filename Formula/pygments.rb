class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/7e/ae/26808275fc76bf2832deb10d3a3ed3107bc4de01b85dcccbe525f2cd6d1e/Pygments-2.4.2.tar.gz"
  sha256 "881c4c157e45f30af185c1ffe8d549d48ac9127433f2c380c24b84572ad66297"

  head "https://github.com/pygments/pygments.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "941b46696318f3d5ff923f4726f05d8e689004952c3efa1880be1e12bd32d80c" => :catalina
    sha256 "7b3db006618f2b67817cf7b73115f0d9548489ae5d2685c9a98f3c6f399ad99c" => :mojave
    sha256 "2b3adbe8bb9d528d5ac26a93dd60d9b3aee6cb4f51f167a9dffe80533ba85e17" => :high_sierra
  end

  depends_on "python"

  def install
    bash_completion.install "external/pygments.bashcomp" => "pygmentize"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
      print(os.getcwd())
    EOS

    system bin/"pygmentize", "-f", "html", "-o", "test.html", testpath/"test.py"
    assert_predicate testpath/"test.html", :exist?
  end
end
