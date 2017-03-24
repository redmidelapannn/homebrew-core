class Bibtex2html < Formula
  desc "BibTeX to HTML converter"
  homepage "https://www.lri.fr/~filliatr/bibtex2html/"
  url "https://www.lri.fr/~filliatr/ftp/bibtex2html/bibtex2html-1.98.tar.gz"
  sha256 "e925a0b97bf87a14bcbda95cac269835cd5ae0173504261f2c60e3c46a8706d6"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "bf033928511d5e29d135da1362f1e1ac36cfedcc34057bcec705c0f8e982c705" => :sierra
    sha256 "0ef4337121272bc1152841a4d70085ce466b7f39eaadb968c6ff6fad28783a0b" => :el_capitan
    sha256 "0cbc75233c8a150235ee197250b94a07c50b0196b6f93d2909a1d6057009deba" => :yosemite
  end

  depends_on "ocaml"
  depends_on "hevea"

  def install
    # See: https://trac.macports.org/ticket/26724
    inreplace "Makefile.in" do |s|
      s.remove_make_var! "STRLIB"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.bib").write <<-EOS.undent
      @article{Homebrew,
          title   = {Something},
          author  = {Someone},
          journal = {Something},
          volume  = {1},
          number  = {2},
          pages   = {3--4}
      }
    EOS
    system "#{bin}/bib2bib", "test.bib", "--remove", "pages", "-ob", "out.bib"
    assert /pages\s*=\s*{3--4}/ !~ File.read("out.bib")
    assert_match /pages\s*=\s*{3--4}/, File.read("test.bib")
  end
end
