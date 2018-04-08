class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/79/3c/2ad76ba49f9e3d88d2b58e135b7821d93741856d1fe49970171f73529303/sqlparse-0.2.4.tar.gz"
  sha256 "ce028444cfab83be538752a2ffdb56bc417b7784ff35bb9a3062413717807dec"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "067c2e3fa5f73756d9df103415df723b3bc239c2789e6442d53eef2c27de5b5b" => :high_sierra
    sha256 "7c08ea6cc60cc50fdff99cec1928a6907baf720779cc9ea67df540b2473b6d4b" => :sierra
    sha256 "d41ff803e7158e6933c129b5df6e0c27e0b692c229ba5d57fc294af91a5a8659" => :el_capitan
  end

  depends_on "python@2"

  def install
    virtualenv_install_with_resources
  end

  test do
    expected = <<~EOS.chomp
      select *
        from foo
    EOS
    output = pipe_output("#{bin}/sqlformat - -a", "select * from foo", 0)
    assert_equal expected, output
  end
end
