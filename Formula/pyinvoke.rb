class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "http://pyinvoke.org/"
  url "https://github.com/pyinvoke/invoke/archive/0.22.1.tar.gz"
  sha256 "0ff243defb9dfdc45a869fb9cc50ba3c0590ef6b337f4df49c465f63911176fb"
  head "https://github.com/pyinvoke/invoke.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e051a85798c3d04a9358e00ead5598cb389d64105e87f3a3a70e73c9b769f195" => :high_sierra
    sha256 "4c05f336bd990bc5010fc34dfb9732cf9229fe0743eae61e032cf22a42f2612e" => :sierra
    sha256 "509d46cab55498cb300e019c259bcf23261cc5c7ddf927af9dd10fe9d665542d" => :el_capitan
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
