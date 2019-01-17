class Latex2rtf < Formula
  desc "Translate LaTeX to RTF"
  homepage "https://latex2rtf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/latex2rtf/latex2rtf-unix/2.3.17/latex2rtf-2.3.17.tar.gz"
  sha256 "19f3763177d8ea7735511438de269b78c24ccbfafcd71d7a47aabc20b9ea05a8"

  bottle do
    rebuild 1
    sha256 "1dafb042767d63222d47d227088caad25cd01a1c98dce564e88f757e2334c8c2" => :mojave
    sha256 "82008707fe0620858a39c7692a75926c92961fd1a304e8b2bf937835a3c09002" => :high_sierra
    sha256 "b60c684746406c7ba045653d327e5e7c75cc1fb1f2f258e8d72ba28b39a793aa" => :sierra
  end

  def install
    inreplace "Makefile", "cp -p doc/latex2rtf.html $(DESTDIR)$(SUPPORTDIR)", "cp -p doc/web/* $(DESTDIR)$(SUPPORTDIR)"
    system "make", "DESTDIR=",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "INFODIR=#{info}",
                   "SUPPORTDIR=#{pkgshare}",
                   "CFGDIR=#{pkgshare}/cfg",
                   "install"
  end
  test do
    (testpath/"test.tex").write <<~EOS
      \documentclass[12pt,twoside,a4paper]{article}
      \begin{document}
      a small \LaTeX document
      \end{document}
    EOS
    
    system bin/"latex2rtf", "test.tex"
    assert_predicate testpath/"test.rtf", :exist?
  end
end
