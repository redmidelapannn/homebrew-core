class Aterm < Formula
  desc "Annotated Term for tree-like ADT exchange"
  homepage "https://strategoxt.org/Tools/ATermFormat"
  url "http://www.meta-environment.org/releases/aterm-2.8.tar.gz"
  sha256 "bab69c10507a16f61b96182a06cdac2f45ecc33ff7d1b9ce4e7670ceeac504ef"

  bottle do
    cellar :any
    rebuild 2
    sha256 "48f233e2e9e0bed97bc24ea0947fe1cb85e291062a19c8390e8542a0d077036f" => :high_sierra
    sha256 "1bd8336938038a0117adeeb25e9057c533475e0fece0e34ad319adb2c9f1d156" => :sierra
    sha256 "2ad471c490ac4e1b97fe9e547a571c61c85a5b19c7efff9fd86394389b5143c1" => :el_capitan
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
