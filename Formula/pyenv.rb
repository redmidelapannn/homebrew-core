class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.3.tar.gz"
  sha256 "cb76cdd39c9207960d3c64b919b1d48376772e7f105953d877c658f2497e4d52"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9ea796ea802ad556fb6f6187da0a9524bc4827ff723e12862ead4598a7749c5e" => :high_sierra
    sha256 "075023011cfc7a0687beaa7a38f0953716054054bef6c2329d007f9fce376291" => :sierra
    sha256 "5cf53aa2fa11c834719d7cd1474f747d8b7f7c746332f1c78025d5f6493a2e61" => :el_capitan
  end

  depends_on "autoconf" => :recommended
  depends_on "pkg-config" => :recommended
  depends_on "openssl" => :recommended
  depends_on "readline" => :recommended

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end
  end

  def caveats; <<~EOS
      To enable shims and autocompletion add to your profile:
        if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init -)" fi

      See: https://github.com/pyenv/pyenv#basic-github-checkout
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
