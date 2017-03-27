class Cppi < Formula
  desc "Indent C preprocessor directives to reflect their nesting"
  homepage "https://www.gnu.org/software/cppi/"
  url "https://ftpmirror.gnu.org/cppi/cppi-1.18.tar.xz"
  mirror "https://ftp.gnu.org/gnu/cppi/cppi-1.18.tar.xz"
  sha256 "12a505b98863f6c5cf1f749f9080be3b42b3eac5a35b59630e67bea7241364ca"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "03e5410e04deb980e26c8c0b2de88b482d3af0234fbd39a86ffb35a47d7a1e15" => :sierra
    sha256 "a2f8d56b5bd48e2fcc9369d66e95ad7a4aaf25038144e379d778f93efb036215" => :el_capitan
    sha256 "a3a18ddccd7feb6e10bc3cce9609f9095a475a64b3f662f532b4742b57121e49" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    test = <<-EOS.undent
      #ifdef TEST
      #include <homebrew.h>
      #endif
    EOS
    assert_equal <<-EOS.undent, pipe_output("#{bin}/cppi", test, 0)
      #ifdef TEST
      # include <homebrew.h>
      #endif
    EOS
  end
end
