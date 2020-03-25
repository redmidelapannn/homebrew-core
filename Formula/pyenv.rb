class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.17.tar.gz"
  sha256 "ff10d1c0e51b2f6e5325bbd7bd4314ddf1e8b7fd00f22652b578ae03c858f74b"
  revision 1
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "b67b3b6cec35cccbd36621d2be31735f2d8df985826f44237fda482392a17b26" => :catalina
    sha256 "9e20d6be6b185386b73e8902a20c02c4a7bc648a98f756ac45a8c5589ff7b10e" => :mojave
    sha256 "340df9770e228004d364ae8edd28d1bc9579878187a4f20e290b1a463c590b12" => :high_sierra
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "python@3.8"
  depends_on "readline"

  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX
    inreplace "libexec/pyenv-versions", "system pyenv-which python", "system pyenv-which python3"

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end

    # Do not manually install shell completions. See:
    #   - https://github.com/pyenv/pyenv/issues/1056#issuecomment-356818337
    #   - https://github.com/Homebrew/homebrew-core/pull/22727
  end

  test do
    # python@3.8 is keg only. Pyenv needs Python 3 in the path
    # to work, so provide our version. Users can later on choose
    # which python they want to use by modifying .pyenv/version
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"

    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
