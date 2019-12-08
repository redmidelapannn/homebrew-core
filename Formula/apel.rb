class Apel < Formula
  desc "Emacs Lisp library to help write portable Emacs programs"
  homepage "http://git.chise.org/elisp/apel/"
  url "http://git.chise.org/elisp/dist/apel/apel-10.8.tar.gz"
  sha256 "a511cc36bb51dc32b4915c9e03c67a994060b3156ceeab6fafa0be7874b9ccfe"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9642acac8f302f67944608afb28ebc26ec9e38a25ec2005b9b171d95058df18a" => :mojave
    sha256 "e4423eb4dcadf47707c0afae83a552865dfc89d891afdbaa0abf2b4105c4a43f" => :high_sierra
  end

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
