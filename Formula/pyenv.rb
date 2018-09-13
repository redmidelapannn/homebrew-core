class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.7.tar.gz"
  sha256 "b5f41187fb71f9fbf2d22d5d18910bdbe473c9f2acdcc5fa2de3f0b53760bb1c"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "22a65681d2139bcdba07d3134455e54e00c09249a41b00bdbb2bdff7219566fd" => :mojave
    sha256 "a144e39ac7ce37eeebd00f784257c536e13590ba2e47dd873abfa071f8bd3178" => :high_sierra
    sha256 "b6cf8ccf26c8bfc01d8e6bbf28e2ba3efc6fddd1c8b671554fbdbdc93463d277" => :sierra
    sha256 "f256c5bf9f5dcc0f57c2f7c3cc96f4a17e374126632e7cbdac071e5c6110ff4b" => :el_capitan
  end

  depends_on "autoconf"
  depends_on "openssl"
  depends_on "pkg-config"
  depends_on "readline"

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
