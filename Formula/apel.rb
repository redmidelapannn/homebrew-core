class Apel < Formula
  desc "Emacs Lisp library to help write portable Emacs programs"
  homepage "http://git.chise.org/elisp/apel/"
  url "http://git.chise.org/elisp/dist/apel/apel-10.8.tar.gz"
  sha256 "a511cc36bb51dc32b4915c9e03c67a994060b3156ceeab6fafa0be7874b9ccfe"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9339b1f7b85158f8f2671d4d219b85b0077d1f95201ac4a886a727ea0df63d7c" => :mojave
    sha256 "06c68ec261bf89c030cc7bb767f1e6946abc63a710eb625bf25745ffc34fbeb9" => :high_sierra
  end

  depends_on "emacs" if MacOS.version >= :catalina

  def install
    system "make", "install", "PREFIX=#{prefix}",
           "LISPDIR=#{elisp}", "VERSION_SPECIFIC_LISPDIR=#{elisp}"
  end

  test do
    program = testpath/"test-apel.el"
    program.write <<~EOS
      (add-to-list 'load-path "#{elisp}/emu")
      (require 'poe)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{program}").strip
  end
end
