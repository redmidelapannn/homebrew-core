class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://github.com/pyinvoke/invoke/archive/1.1.1.tar.gz"
  sha256 "772b340244c16db1910ed91c61bc1a817ba87bed66156d99af9ebddc14869e64"
  head "https://github.com/pyinvoke/invoke.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3a9d2552ac0dab4178226bca4920e43920da42010a389e80c365da1b4a9ab44e" => :mojave
    sha256 "0e68c69418e0ff6c93a0673584d868ddf6a78293b4225412f7e48ba8bea23f9e" => :high_sierra
    sha256 "77d8a43ef5826186d203a697a43da3c04a475eb9c46d2bbecb36eddb270a84e0" => :sierra
    sha256 "c9b1ac07708b1f6e1ea6f1239800a2b48b0889a9e4c7987d61dcee29f9e9edc4" => :el_capitan
  end

  depends_on "python@2"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"tasks.py").write <<~EOS
      from invoke import run, task

      @task
      def clean(ctx, extra=''):
          patterns = ['foo']
          if extra:
              patterns.append(extra)
          for pattern in patterns:
              run("rm -rf {}".format(pattern))
    EOS
    (testpath/"foo"/"bar").mkpath
    (testpath/"baz").mkpath
    system bin/"invoke", "clean"
    refute_predicate testpath/"foo", :exist?, "\"pyinvoke clean\" should have deleted \"foo\""
    assert_predicate testpath/"baz", :exist?, "pyinvoke should have left \"baz\""
    system bin/"invoke", "clean", "--extra=baz"
    refute_predicate testpath/"foo", :exist?, "\"pyinvoke clean-extra\" should have still deleted \"foo\""
    refute_predicate testpath/"baz", :exist?, "pyinvoke clean-extra should have deleted \"baz\""
  end
end
