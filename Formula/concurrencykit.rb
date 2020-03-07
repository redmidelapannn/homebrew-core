class Concurrencykit < Formula
  desc "Aid design and implementation of concurrent systems"
  homepage "http://concurrencykit.org"
  url "http://concurrencykit.org/releases/ck-0.6.0.tar.gz"
  mirror "https://github.com/concurrencykit/ck/archive/0.6.0.tar.gz"
  sha256 "d7e27dd0a679e45632951e672f8288228f32310dfed2d5855e9573a9cf0d62df"
  head "https://github.com/concurrencykit/ck.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2281318115365a92c59d9644f192ddf2654d77679919778f65bbd9aea86b009b" => :catalina
    sha256 "a12efeadf4d80ce047e86ec5c420b548df153d0c79c976cc91e31f8db3408953" => :mojave
    sha256 "a4cf532a224e9a7fa88a4b21c18505afa30f649e9c17e6f75c3b305f4023d04c" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ck_spinlock.h>
      int main()
      {
        ck_spinlock_t spinlock;
        ck_spinlock_init(&spinlock);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lck",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
