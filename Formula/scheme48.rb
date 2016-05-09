class Scheme48 < Formula
  desc "Scheme byte-code interpreter"
  homepage "http://www.s48.org/"
  url "http://s48.org/1.9.2/scheme48-1.9.2.tgz"
  sha256 "9c4921a90e95daee067cd2e9cc0ffe09e118f4da01c0c0198e577c4f47759df4"

  bottle do
    revision 2
    sha256 "e8306c14ee6b99c29d27e9e9f51412e8db287597a2074fb66a33485377598654" => :el_capitan
    sha256 "1171d387c58bdeb809892eaf7a8a64003b2d168b956a0a449b5531815a2aba01" => :yosemite
    sha256 "36fa5317ffc39af1fc588145498c2638ab4fa7c76e79454f1845fdec4d77c821" => :mavericks
  end

  conflicts_with "gambit-scheme", :because => "both install `scheme-r5rs` binaries"
  conflicts_with "scsh", :because => "both install include/scheme48.h"

  def install
    ENV.O0 if ENV.compiler == :clang
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--enable-gc=bibop"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"hello.scm").write <<-EOS.undent
      (display "Hello, World!") (newline)
    EOS

    expected = <<-EOS.undent
      Hello, World!\#{Unspecific}

      \#{Unspecific}

    EOS

    assert_equal expected, shell_output("#{bin}/scheme48 -a batch < hello.scm")
  end
end
