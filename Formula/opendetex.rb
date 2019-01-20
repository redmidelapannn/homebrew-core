class Opendetex < Formula
  desc "Tool to strip TeX or LaTeX commands from documents"
  homepage "https://github.com/pkubowicz/opendetex"
  url "https://github.com/pkubowicz/opendetex/archive/v2.8.4.tar.gz"
  sha256 "d1ca2ba332d0b948b3316052476d3699a7378ab83505fe906a2ba80828778f84"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6b2921e62a18a6e60eab35000d2be5644bbbef2b5ae78ae36adea8d13dec41b7" => :mojave
    sha256 "525cdc8ee6e899f6ace5b3b6b5f6bd0fffe5e28ca1f625065a0016bc27d0d91c" => :high_sierra
    sha256 "ec7f3b980d4b52882a6670c72c8bb6086328a7e23e4f5f0fe72b563033dc946c" => :sierra
  end

  patch :DATA

  def install
    system "make"
    bin.install "detex"
    bin.install "delatex"
    man1.install "detex.1l" => "detex.1"
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      Simple \\emph{text}.
      \\end{document}
    EOS

    output = shell_output("#{bin}/detex test.tex")
    assert_equal "Simple text.\n", output
  end
end

__END__
diff --git a/detex.1l b/detex.1l
index a70c813..7033b44 100644
--- a/detex.1l
+++ b/detex.1l
@@ -1,4 +1,4 @@
-.TH DETEX 1L "12 August 1993" "Purdue University"
+.TH DETEX 1 "12 August 1993" "Purdue University"
 .SH NAME
 detex \- a filter to strip \fITeX\fP commands from a .tex file.
 .SH SYNOPSIS
@@ -103,7 +103,7 @@ The old functionality can be essentially duplicated by using the
 .B \-s
 option.
 .SH SEE ALSO
-tex(1L)
+tex(1)
 .SH DIAGNOSTICS
 Nesting of \\input is allowed but the number of opened files must not
 exceed the system's limit on the number of simultaneously opened files.
