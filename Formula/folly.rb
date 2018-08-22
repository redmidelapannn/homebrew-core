class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2018.08.20.00.tar.gz"
  sha256 "3a18fa5564feee64aa5bcdaf3bbe1c63b4ed728da23dcc8ab9c3d8416d71a3cd"
  revision 1
  head "https://github.com/facebook/folly.git"

  bottle do
    sha256 "2c37ea97c227ddab9c7ebd5617f58107bf54904742e38321ed28218cc5a5caa2" => :high_sierra
    sha256 "7978cfbb7f9a39f62fc8f78a0d4b1523b3e1afe20c036c26409d90f518b4b3d1" => :sierra
    sha256 "18fa9bd140f32567520f770ae49042181f086b3e833b264f2937176b9c26b73a" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "double-conversion"
  depends_on "glog"
  depends_on "gflags"
  depends_on "boost@1.67"
  depends_on "libevent"
  depends_on "xz"
  depends_on "snappy"
  depends_on "lz4"
  depends_on "openssl"

  # https://github.com/facebook/folly/issues/451
  depends_on :macos => :el_capitan

  needs :cxx11

  # Known issue upstream. They're working on it:
  # https://github.com/facebook/folly/pull/445
  fails_with :gcc => "6"

  def install
    ENV.cxx11

    cd "folly" do
      system "autoreconf", "-fvi"
      system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                            "--disable-dependency-tracking",
                            "--with-boost=#{Formula["boost@1.67"].opt_prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
