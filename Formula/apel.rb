class Apel < Formula
  desc "Emacs Lisp library to help write portable Emacs programs"
  homepage "http://git.chise.org/elisp/apel/"
  url "http://git.chise.org/elisp/dist/apel/apel-10.8.tar.gz"
  sha256 "a511cc36bb51dc32b4915c9e03c67a994060b3156ceeab6fafa0be7874b9ccfe"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b6c6302fbe4ba252c4f54ee402db9f9857beae7ee451f3189fe18f79557e4764" => :mojave
    sha256 "d21ff2bbd3886d0cebaa870ac2115ca3adba8d069001f728ab1eb62bd658c573" => :high_sierra
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
    assert_equal "0", shell_output("#{Formula["emacs"].bin}/emacs -Q --batch -l #{program}").strip
  end
end
