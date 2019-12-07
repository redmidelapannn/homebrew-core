class Trr < Formula
  desc "Type training program for emacs users"
  homepage "https://code.google.com/archive/p/trr22/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/trr22/trr22_0.99-5.tar.gz"
  version "22.0.99.5"
  sha256 "6bac2f947839cebde626cdaab0c0879de8f6f6e40bfd7a14ccdfe1a035a3bcc6"
  revision 1

  bottle do
    rebuild 1
    sha256 "454b920e8c725c72b9e524b2c114dc665918513a95210e2fce8e6d87de417676" => :mojave
    sha256 "893b4ea99eaf28f8f2febf49beb4f853369fc2b0a05c1f040f05abe198439611" => :high_sierra
  end

  depends_on "nkf" => :build
  depends_on "apel"

  def install
    system "make", "clean"
    cp Dir["#{Formula["apel"].opt_elisp}/**/*.el"], buildpath

    # The file "CONTENTS" is firstly encoded to EUC-JP.
    # This encodes it to UTF-8 to avoid garbled characters.
    system "nkf", "-w", "--overwrite", buildpath/"CONTENTS"

    # wrong text filename
    inreplace buildpath/"CONTENTS", "EmacsLisp", "Elisp_programs"

    system "make", "clean"
    cp Dir["#{Formula["apel"].opt_elisp}/**/*.elc"], buildpath

    # texts for playing trr
    texts = "The_Constitution_Of_JAPAN Constitution_of_the_USA Iccad_90 C_programs Elisp_programs Java_programs Ocaml_programs Python_programs"

    inreplace buildpath/"Makefile", "japanese = t", "japanese = nil"

    system "make", "install",
                   "CC=#{ENV.cc}",
                   "TRRDIR=#{prefix}",
                   "INFODIR=#{info}",
                   "BINDIR=#{bin}",
                   "TEXTS=#{texts}",
                   "LISPDIR=#{elisp}"
    (prefix/"record").install Dir["record/*"]
  end

  test do
    program = testpath/"test-trr.el"
    program.write <<~EOS
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/apel/emu")
      (add-to-list 'load-path "#{elisp}")
      (require 'trr)
      (print (TRR:trainer-menu-buffer))
    EOS

    assert_equal "\"Type & Menu\"", shell_output("emacs -Q --batch -l #{program}").strip
  end
end
