class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftpmirror.gnu.org/gdbm/gdbm-1.12.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gdbm/gdbm-1.12.tar.gz"
  sha256 "d97b2166ee867fd6ca5c022efee80702d6f30dd66af0e03ed092285c3af9bcea"

  bottle do
    cellar :any
    revision 1
    sha256 "39bbc0b80daab95153f92b3b38df4cc32bab59e5be6f1d2b5dda0fd124ee1268" => :el_capitan
    sha256 "33923d17f25233e36389c8495c5fb7053ba88bef38f6a742cde7c0499f90f524" => :yosemite
    sha256 "28ff06dcefa5e5ea0b66e8fbd1bd3b338c27bdd6bde184d0765f5be634d917b7" => :mavericks
  end

  option :universal
  option "with-libgdbm-compat", "Build libgdbm_compat, a compatibility layer which provides UNIX-like dbm and ndbm interfaces."

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--enable-libgdbm-compat" if build.with? "libgdbm-compat"

    system "./configure", *args
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert File.exist?("test")
    assert_match /2/, pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end
