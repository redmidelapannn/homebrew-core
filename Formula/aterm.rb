class Aterm < Formula
  desc "AfterStep terminal emulator"
  homepage "https://strategoxt.org/Tools/ATermFormat"
  url "http://www.meta-environment.org/releases/aterm-2.8.tar.gz"
  sha256 "bab69c10507a16f61b96182a06cdac2f45ecc33ff7d1b9ce4e7670ceeac504ef"

  bottle do
    cellar :any
    rebuild 2
    sha256 "bdbf4879962e692451bbe5d7b48be3db60fb6ecd517672a2d1ac7f8393f2e335" => :high_sierra
    sha256 "5e8e36c2a1e57da00b4b62138b8b86ac3d78eb1690d4d97201adb001add5f8ad" => :sierra
    sha256 "2f93752a0dda522e523d177ac9d9002463fc33f225ad70a5e1f69f60094510d1" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    ENV.deparallelize # Parallel builds don't work
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <aterm1.h>

      int main(int argc, char *argv[]) {
        ATerm bottomOfStack;
        ATinit(argc, argv, &bottomOfStack);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lATerm", "-o", "test"
    system "./test"
  end
end
