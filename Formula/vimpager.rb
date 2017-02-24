class Vimpager < Formula
  desc "Use ViM as PAGER"
  homepage "https://github.com/rkitover/vimpager"
  url "https://github.com/rkitover/vimpager/archive/2.06.tar.gz"
  sha256 "cc616d0840a6f2501704eea70de222ab662421f34b2da307e11fb62aa70bda5d"
  head "https://github.com/rkitover/vimpager.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ba13b5fa559ca441045c2b9e2f24831528e4b87998651cb05b8f1fa27aad5954" => :sierra
    sha256 "ba13b5fa559ca441045c2b9e2f24831528e4b87998651cb05b8f1fa27aad5954" => :el_capitan
    sha256 "ba13b5fa559ca441045c2b9e2f24831528e4b87998651cb05b8f1fa27aad5954" => :yosemite
  end

  option "with-pandoc", "Use pandoc to build and install man pages"
  depends_on "pandoc" => [:build, :optional]

  def install
    system "make", "install", "PREFIX=#{prefix}"
    system "make", "docs" if build.with? "pandoc"
  end

  def caveats; <<-EOS.undent
    To use vimpager as your default pager, add `export PAGER=vimpager` to your
    shell configuration.
    EOS
  end

  test do
    (testpath/"test.txt").write <<-EOS.undent
      This is test
    EOS

    assert_match(/This is test/, shell_output("#{bin}/vimcat test.txt"))
  end
end
