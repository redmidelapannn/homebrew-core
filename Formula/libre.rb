class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.5.4.tar.gz"
  mirror "https://ftp.openbsd.org/pub/OpenBSD/distfiles/re-0.5.4.tar.gz"
  sha256 "695370c15d839dafbbb4c0222a22ee0af4859475b0b1b66e52ccb854cd91060c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c5b867cf9a46d763235cdabba3356232c073985861f7d51b04332e3c39f43035" => :sierra
    sha256 "7266dbea7c64bc01f07d888c41b2f458a56dd94ab35c4731713cde12e559c985" => :el_capitan
  end

  depends_on "openssl"
  depends_on "lzlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lre"
  end
end
