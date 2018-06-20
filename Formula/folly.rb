class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2018.06.18.00.tar.gz"
  sha256 "aa4aa8f4ef18a3bddf06a7ed9349f172b2bbad11cbc0606cdc91517ffe7ee809"
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cd4393bc8cf1f5253832e8df14ccda8caac106757bbee7de8d6e8db3647fcac6" => :high_sierra
    sha256 "1f326f83d18300ec9b59ba161880447348d13ab2767f454be1349885b1b896ab" => :sierra
    sha256 "ff3277b6819721dab2d9493c386269eaf80e848255093da814bd668dbc3bb169" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "double-conversion"
  depends_on "glog"
  depends_on "gflags"
  depends_on "boost"
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

    args = std_cmake_args + %w[
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    # https://github.com/facebook/folly/issues/864
    args << "-DCOMPILER_HAS_F_ALIGNED_NEW=OFF" if MacOS.version == :sierra

    mkdir "_build" do
      system "cmake", "configure", "..", *args
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
