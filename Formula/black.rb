class Black < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https://black.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/b0/dc/ecd83b973fb7b82c34d828aad621a6e5865764d52375b8ac1d7a45e23c8d/black-19.10b0.tar.gz"
  sha256 "c2edb73a08e9e0e6f65a0e6af18b059b8b1cdd5bef997d7a0b181df93dc81539"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4d0344055d9da78d9c6f1c56a596ce10ea90e1fdbe15d7ba55644a16940a94af" => :catalina
    sha256 "5f19c383a86ddbb212842a5e028b3e1ceae26503d30da1ec6c9bd3fefe1c72e7" => :mojave
    sha256 "6975c756119fcd1f3e63f6441eb45164f662e02ba9b0ed699cc5ce712596f6fe" => :high_sierra
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "black"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/black --version")

    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"black_test.py").write <<~EOS
      print(
      'It works!')
    EOS
    system bin/"black", "black_test.py"
    assert_equal "print(\"It works!\")\n", (testpath/"black_test.py").read
  end
end
