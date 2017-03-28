class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.ctan.org/pkg/latex2html"
  url "http://mirrors.ctan.org/support/latex2html/latex2html-2016.tar.gz"
  sha256 "ab1dbc18ab0ec62f65c1f8c14f2b74823a0a2fc54b07d73ca49524bcae071309"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9042c58e5c3e4d695de59c2f2199bea755196bb631a8e9a07ae46e6b7c7f20e2" => :sierra
    sha256 "86b8d21cacd8dab019c4b716a14fc47a70bbff759648367152f74a1df9753819" => :el_capitan
    sha256 "79157537d0d6abeb506afb6f84b364ae2b5df36c12dc08828860008b3f6d0d31" => :yosemite
  end

  depends_on "netpbm"
  depends_on "ghostscript"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--without-mktexlsr",
                          "--with-texpath=#{share}/texmf/tex/latex/html"
    system "make", "install"
  end

  test do
    (testpath/"test.tex").write <<-EOS.undent
      \\documentclass{article}
      \\usepackage[utf8]{inputenc}
      \\title{Experimental Setup}
      \\date{November 2016}
      \\usepackage{natbib}
      \\usepackage{graphicx}
      \\begin{document}
      \\maketitle

      \\section{Experimental Setup}
        \\textbf{it works!}

      \\end{document}
    EOS
    system "#{bin}/latex2html", "test.tex"
    assert_match /Experimental Setup/, File.read("test/test.html")
  end
end
