class Cuetools < Formula
  desc "Utilities for .cue and .toc files"
  homepage "https://github.com/svend/cuetools"
  url "https://github.com/svend/cuetools/archive/1.4.1.tar.gz"
  sha256 "24a2420f100c69a6539a9feeb4130d19532f9f8a0428a8b9b289c6da761eb107"

  head "https://github.com/svend/cuetools.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b66e54a12bbddedd49d5d29ba1bc43afaef5a572c247d9197ff66afe2e1be0be" => :high_sierra
    sha256 "c5cb327de3373f0329474a8b1a0d6269f813a5c7fc299c856ba33994b8f3073f" => :sierra
    sha256 "dfcd6c54b233ae2684af1155c0f3d71cd12fddeeddf43616e8fbe16633d76b6c" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # see https://github.com/svend/cuetools/pull/18
  patch :DATA

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.cue").write <<-EOS.undent
      FILE "sampleimage.bin" BINARY
        TRACK 01 MODE1/2352
          INDEX 01 00:00:00
    EOS
    system "cueconvert", testpath/"test.cue", testpath/"test.toc"
    assert_predicate testpath/"test.toc", :exist?
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index f54bb92..84ab467 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,5 +1,5 @@
 AC_INIT([cuetools], [1.4.0], [svend@ciffer.net])
-AM_INIT_AUTOMAKE([-Wall -Werror foreign])
+AM_INIT_AUTOMAKE([-Wall -Werror -Wno-extra-portability foreign])
 AC_PROG_CC
 AC_PROG_INSTALL
 AC_PROG_RANLIB
