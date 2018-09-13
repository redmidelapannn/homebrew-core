class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.2.tar.gz"
  sha256 "4005e714db78b073c1ef8bde55485452dc7a31e3b8cc0b4d60d6112ffb5ea228"
  revision 1
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c73a5415a45aa9d4fe7647a54b59f76d48fe893b328668990f2e9f223ea7272e" => :mojave
    sha256 "197bcc6a99dd7fa06e700eb1e101843468e14310cd85fda5def261c271f42b3b" => :high_sierra
    sha256 "197bcc6a99dd7fa06e700eb1e101843468e14310cd85fda5def261c271f42b3b" => :sierra
    sha256 "197bcc6a99dd7fa06e700eb1e101843468e14310cd85fda5def261c271f42b3b" => :el_capitan
  end

  depends_on "sphinx-doc" => :build
  depends_on "pyqt"
  depends_on "python"

  def install
    ENV.delete("PYTHONPATH")
    system "make", "PYTHON=python3", "prefix=#{prefix}", "install"
    system "make", "install-doc", "PYTHON=python3", "prefix=#{prefix}",
           "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
