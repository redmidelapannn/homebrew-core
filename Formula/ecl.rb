class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/static/files/release/ecl-16.1.3.tgz"
  sha256 "76a585c616e8fa83a6b7209325a309da5bc0ca68e0658f396f49955638111254"
  revision 4
  head "https://gitlab.com/embeddable-common-lisp/ecl.git"

  bottle do
    sha256 "a3dfc700673e2af0c43446a912087161b5d76dcfd6fcf0a9c8d67137f2dd64db" => :catalina
    sha256 "926d576bb0ffdedb160ecf037c69e92a0f143a41927b9abc973b34a4a5a72cb5" => :mojave
    sha256 "7782b31b77d8158c443d4a0f2271ef82166c77b41cd93c6756287f6debaf8352" => :high_sierra
  end

  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libffi"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads=yes",
                          "--enable-boehm=system",
                          "--enable-gmp=system"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"simple.cl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    assert_equal "4", shell_output("#{bin}/ecl -shell #{testpath}/simple.cl").chomp
  end
end
