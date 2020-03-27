class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  url "https://downloads.sourceforge.net/project/asymptote/2.65/asymptote-2.65.src.tgz"
  sha256 "15e3d71a0c492c9f2142dd86a7390bcbf59c944ec8b86970833599ff37c59844"

  bottle do
    sha256 "f3e6ecf1c6ff24c68aaca04a1b34ad57ccf0fee2807c550d2df4d765f410ce2a" => :catalina
    sha256 "995fcd7751d17c77dc073b7cc42b878b216d2ba79222a1fbc1cb9f2c59dcf159" => :mojave
    sha256 "39f477df77b332f52cf0dc2193a5dc09c7ff9241781d040b60f461dc757cf80f" => :high_sierra
  end

  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "glm"
  depends_on "gsl"

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.65/asymptote.pdf"
    sha256 "9a3aafacab8e09ca677972321d04c3fe9a335adad960e5f22ab30ab5fb82b705"
  end

  def install
    system "./configure", "--prefix=#{prefix}"

    # Avoid use of MacTeX with these commands
    # (instead of `make all && make install`)
    touch buildpath/"doc/asy-latex.pdf"
    system "make", "asy"
    system "make", "asy-keywords.el"
    system "make", "install-asy"

    doc.install resource("manual")
    (share/"emacs/site-lisp").install_symlink pkgshare
  end

  test do
    (testpath/"line.asy").write <<~EOF
      settings.outformat = "pdf";
      size(200,0);
      draw((0,0)--(100,50),N,red);
    EOF
    system "#{bin}/asy", testpath/"line.asy"
    assert_predicate testpath/"line.pdf", :exist?
  end
end
