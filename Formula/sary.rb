class Sary < Formula
  desc "Suffix array library"
  homepage "https://sary.sourceforge.io/"
  url "https://sary.sourceforge.io/sary-1.2.0.tar.gz"
  sha256 "d4b16e32c97a253b546922d2926c8600383352f0af0d95e2938b6d846dfc6a11"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f295899c6c862d9f3f8fe592f4fdbbbc5985ec44d3c769304d168d740002eabb" => :sierra
    sha256 "2279aecb95732c4bf1f4c2f925050450a64ecb9634f000b5b2c90e73437d13f0" => :el_capitan
    sha256 "91fee767f543965f96b9289ff4768e42c43bc123f5186b503627f9423e4988b8" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test").write <<-EOS.undent
      Some text,
      this is the Sary formula, a suffix array library and tools,
      more text.
      more. text.
    EOS

    system "#{bin}/mksary", "test"
    assert File.exist? "test.ary"

    assert_equal "Some text,\nmore text.\nmore. text.",
      shell_output("#{bin}/sary text test").chomp
  end
end
