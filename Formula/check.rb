class Check < Formula
  desc "C unit testing framework"
  homepage "https://libcheck.github.io/check/"
  url "https://downloads.sourceforge.net/project/check/check/0.10.0/check-0.10.0.tar.gz"
  sha256 "f5f50766aa6f8fe5a2df752666ca01a950add45079aa06416b83765b1cf71052"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3f9409ccb0a99fc4678c55c16f02aed91e7e977a0629f9bb267dfac2d513a8f6" => :sierra
    sha256 "824d01636208ff6e7c86a21e4a1fb1d6546dd38e2fd4e1a48e05775958005e9d" => :el_capitan
    sha256 "9c3cd61c8ef36f03ff44b5fd39259b5748d5ece91e1cefbffc1a456a508f8943" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.tc").write <<-EOS.undent
      #test test1
      ck_assert_msg(1, "This should always pass");
    EOS

    system "#{bin/"checkmk"} test.tc > test.c"

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcheck", "-o", "test"
    system "./test"
  end
end
