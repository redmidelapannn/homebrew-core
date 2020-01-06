class Apel < Formula
  desc "Emacs Lisp library to help write portable Emacs programs"
  homepage "http://git.chise.org/elisp/apel/"
  url "http://git.chise.org/elisp/dist/apel/apel-10.8.tar.gz"
  sha256 "a511cc36bb51dc32b4915c9e03c67a994060b3156ceeab6fafa0be7874b9ccfe"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d8a7e747d68ce57b5ffeb4e5a5a51d8cd943631f50377d34be3f169d34e9e4f6" => :mojave
    sha256 "e9f6bf4cec66d06d3278506abcd6d1f475fc3ad6242749ab309d541294e42447" => :high_sierra
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
