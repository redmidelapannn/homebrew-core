class Judy < Formula
  desc "C library that implements a sparse dynamic array"
  homepage "https://judy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/judy/judy/Judy-1.0.5/Judy-1.0.5.tar.gz"
  sha256 "d2704089f85fdb6f2cd7e77be21170ced4b4375c03ef1ad4cf1075bd414a63eb"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2f6181dd6e87b6bf6593520bbefac9441e19112b5c00c7755cd7d44cb8fc91d8" => :sierra
    sha256 "48359aa6e28067bcca7e55005ad75561dc9524ad55416023a2fd9d28baa08045" => :el_capitan
    sha256 "dfea5c58a48f2bb3160123b99b339d8cc509ac6de8566a9ba8d6d04425074efc" => :yosemite
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <Judy.h>
      int main() {
        PPvoid_t judy = NULL;
        Word_t index = 10;
        int ret;
        J1T(ret, judy, index);
        return ret;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lJudy", "-o", "test"
    system "./test"
  end
end
