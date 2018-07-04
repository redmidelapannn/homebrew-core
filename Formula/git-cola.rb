class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.1.tar.gz"
  sha256 "a7a083f84697a56ee7c910ccfc680d36c5c447c6b5a3522e01bff9de91474f57"
  revision 1
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "944eb0d0c300ee20cbfdd0b987d0e532e7dbca75cb75411e31043ae49af9253a" => :high_sierra
    sha256 "944eb0d0c300ee20cbfdd0b987d0e532e7dbca75cb75411e31043ae49af9253a" => :sierra
    sha256 "944eb0d0c300ee20cbfdd0b987d0e532e7dbca75cb75411e31043ae49af9253a" => :el_capitan
  end

  option "with-docs", "Build manpages and HTML docs"

  depends_on "pyqt"
  depends_on "python"
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
