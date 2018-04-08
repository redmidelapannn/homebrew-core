class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "http://cython.org"
  url "https://files.pythonhosted.org/packages/be/08/bb5ffd1c32a951cbc26011ecb8557e59dc7a0a4975f0ad98b2cd7446f7dd/Cython-0.28.1.tar.gz"
  sha256 "152ee5f345012ca3bb7cc71da2d3736ee20f52cd8476e4d49e5e25c5a4102b12"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b6d7cec469062caa58528b0d5e5713169f75c0422218e89f41e006732e5c3b60" => :high_sierra
    sha256 "9f68d4669927ea441831f3ebe78fb3062621030876212648cf1d7db8b0af2f98" => :sierra
    sha256 "2393e069dac9a2f0ffdecf03806c4e79cdae062eccfd19772a88db5f8c47d31e" => :el_capitan
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@2"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system "python", "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("python -c 'import package_manager'")
  end
end
