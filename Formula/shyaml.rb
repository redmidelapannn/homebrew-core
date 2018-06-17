class Shyaml < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML parser"
  homepage "https://github.com/0k/shyaml"
  url "https://files.pythonhosted.org/packages/33/34/7ad4b645bdd5c6cd100748fc2429924b553439221aa9b9386f658e5a05f2/shyaml-0.5.2.tar.gz"
  sha256 "80650ebfe6fa2e16083451d515207472d60990c1c15fc0fd607c27077790ac23"
  head "https://github.com/0k/shyaml.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bce91aaf64c73f2df08001bbb7f7d8ebc7d51d832886c308cca1ba8afb85e8fc" => :high_sierra
    sha256 "e7c7b970c08af35ab6779791d977a20598819aa51908472f1fc0b00136357ef5" => :sierra
    sha256 "232a44e8704d7a78535a5534881c10863d4fe04c0972dea0aae3ac39afd63c42" => :el_capitan
  end

  depends_on "python"
  depends_on "libyaml"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    yaml = <<~EOS
      key: val
      arr:
        - 1st
        - 2nd
    EOS
    assert_equal "val", pipe_output("#{bin}/shyaml get-value key", yaml, 0)
    assert_equal "1st", pipe_output("#{bin}/shyaml get-value arr.0", yaml, 0)
    assert_equal "2nd", pipe_output("#{bin}/shyaml get-value arr.-1", yaml, 0)
  end
end
