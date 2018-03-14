class Latexdiff < Formula
  desc "Determine and markup differences between two LaTeX files"
  homepage "https://www.ctan.org/pkg/latexdiff"
  url "https://github.com/ftilmann/latexdiff/releases/download/1.2.1/latexdiff-1.2.1.tar.gz"
  sha256 "12634c8ec5c68b173d3906679bb09330e724491c6a64e675989217cf4790604e"

  def install
    # Replace standard latexdiff with latexdiff-so which uses an inlined
    # version of the Perl algorithm Algorithm::Diff.
    # This is the preferred method according to the README
    cp "latexdiff-so", "latexdiff"
    bin.install %w[latexdiff latexdiff-fast latexdiff-so latexdiff-vc
                   latexrevise]
    man1.install %w[latexdiff-vc.1 latexdiff.1 latexrevise.1]
    doc.install Dir["doc/*"]
    pkgshare.install %w[contrib example]
  end

  test do
    (testpath/"test1.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      Hello, world.
      \\end{document}
    EOS

    (testpath/"test2.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      Goodnight, moon.
      \\end{document}
    EOS

    expect = /^\\DIFdelbegin \s+
             \\DIFdel      \{ Hello,[ ]world \}
             \\DIFdelend   \s+
             \\DIFaddbegin \s+
             \\DIFadd      \{ Goodnight,[ ]moon \}
             \\DIFaddend   \s+
             \.$/x
    assert_match expect, shell_output("#{bin}/latexdiff test[12].tex")
  end
end
