class Jed < Formula
  desc "Powerful editor for programmers"
  homepage "https://www.jedsoft.org/jed/"
  url "https://www.jedsoft.org/releases/jed/jed-0.99-19.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/j/jed/jed_0.99.19.orig.tar.gz"
  sha256 "5eed5fede7a95f18b33b7b32cb71be9d509c6babc1483dd5c58b1a169f2bdf52"

  bottle do
    rebuild 1
    sha256 "8546fadbe8b5bfb4c1128ff2c284d9911100adf1be7688f7445e28c14288627d" => :high_sierra
    sha256 "a8f3f9cae1de210a2838a993bcb5c5af7fcb1b603c0d9d3254efaa47d2fc29b2" => :sierra
    sha256 "546370997c9ece8d222edcbad28b5cc3ff11a71228f2bac84c8c53ea705bca49" => :el_capitan
  end

  head do
    url "git://git.jedsoft.org/git/jed.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "s-lang"
  depends_on :x11 => :optional

  def install
    if build.head?
      cd "autoconf" do
        system "make"
      end
    end
    system "./configure", "--prefix=#{prefix}",
                          "--with-slang=#{Formula["s-lang"].opt_prefix}"
    system "make"
    system "make", "xjed" if build.with? "x11"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.sl").write "flush (\"Hello, world!\");"
    assert_equal "Hello, world!",
                 shell_output("#{bin}/jed -script test.sl").chomp
  end
end
