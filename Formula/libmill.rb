class Libmill < Formula
  desc "Go-style concurrency in C"
  homepage "http://libmill.org/"
  url "http://libmill.org/libmill-1.18.tar.gz"
  sha256 "12e538dbee8e52fd719a9a84004e0aba9502a6e62cd813223316a1e45d49577d"
  head "https://github.com/sustrik/libmill.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "93cb370861d980e70a396545439463db6393a697adc04a97add69ecb7f1e3eee" => :mojave
    sha256 "4e81b9641391658bdf313d406c3ec6b4be735057d7db82ae4a34abcca1b5f127" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "all", "check", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libmill.h>

      void worker(int count, const char *text) {
          int i;
          for(i = 0; i != count; ++i) {
              printf("%s\\n", text);
              msleep(10);
          }
      }

      int main() {
          go(worker(4, "a"));
          go(worker(2, "b"));
          go(worker(3, "c"));
          msleep(100);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmill", "-o", "test"
    system "./test"
  end
end
