class Vimpager < Formula
  desc "Use ViM as PAGER"
  homepage "https://github.com/rkitover/vimpager"
  url "https://github.com/rkitover/vimpager/archive/2.06.tar.gz"
  sha256 "cc616d0840a6f2501704eea70de222ab662421f34b2da307e11fb62aa70bda5d"
  head "https://github.com/rkitover/vimpager.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9b467ef4515bc71934eb73050f08759ef34f4ada29ada7b6be55691d9ed475f3" => :sierra
    sha256 "9b467ef4515bc71934eb73050f08759ef34f4ada29ada7b6be55691d9ed475f3" => :el_capitan
    sha256 "9b467ef4515bc71934eb73050f08759ef34f4ada29ada7b6be55691d9ed475f3" => :yosemite
  end

  option "with-pandoc", "Use pandoc to build and install man pages"
  depends_on "pandoc" => [:build, :optional]

  def install
    system "make", "docs" if build.with? "pandoc"
    bin.install "vimcat"
    bin.install "vimpager"
    if build.head?
      doc.install "README.md"
    else
      doc.install "README.md", "vimcat.md", "vimpager.md"
    end
    man1.install "vimcat.1", "vimpager.1" if build.with? "pandoc"
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
