class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://github.com/twolfson/restructuredtext-lint/archive/1.1.3.tar.gz"
  sha256 "eb75dda827c656a33be6e60f18b3943c4dd4252205e557ec95d1cf44df8e3a35"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "57ccc09fa5539733e6ed7c40454ca58fea33ab2b237d38244087ba41994e5069" => :high_sierra
    sha256 "e501b5a7af6a4bf9d89ba1d05adc1597d8d1b7f32b60dc9257e40bcedd55bfc0" => :sierra
    sha256 "29edcf86402638045a68c2263d48ad8261a8e3a618751273cd60affc8ac6d107" => :el_capitan
  end

  depends_on "python@2"

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # test invocation on a file with no issues
    (testpath/"pass.rst").write <<~EOS
      Hello World
      ===========
    EOS
    assert_equal "", shell_output("#{bin}/rst-lint pass.rst")

    # test invocation on a file with a whitespace style issue
    (testpath/"fail.rst").write <<~EOS
      Hello World
      ==========
    EOS
    output = shell_output("#{bin}/rst-lint fail.rst", 2)
    assert_match "WARNING fail.rst:2 Title underline too short.", output
  end
end
