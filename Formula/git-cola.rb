class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.11.tar.gz"
  sha256 "bc4007e0d9c80763ef58d630b033bfdbd8406af77bbd292a6c647ed3ca655b5b"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "25b84a658f502488cca76e239d007e1b6dfbfb6530432ab689f1145768f9cb4b" => :high_sierra
    sha256 "427a9210c1d9925ddcae7b544e0c968d462b01cf3e861f5d47a1cceff6ee3d22" => :sierra
    sha256 "427a9210c1d9925ddcae7b544e0c968d462b01cf3e861f5d47a1cceff6ee3d22" => :el_capitan
  end

  option "with-docs", "Build manpages and HTML docs"

  depends_on "pyqt"
  depends_on :python3
  depends_on "sphinx-doc" => :build if build.with? "docs"

  def install
    ENV.delete("PYTHONPATH")
    system "make", "PYTHON=python3", "prefix=#{prefix}", "install"

    if build.with? "docs"
      system "make", "install-doc", "PYTHON=python3", "prefix=#{prefix}",
             "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
    end
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
