class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.haxx.se/"
  url "https://c-ares.haxx.se/download/c-ares-1.15.0.tar.gz"
  sha256 "6cdb97871f2930530c97deb7cf5c8fa4be5a0b02c7cea6e7c7667672a39d6852"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a040d5f7e56497a1c0d7dfeefc613f961a1c05102c4fd246e0e5cda15d0a8bcb" => :mojave
    sha256 "bae3b48267803fb0acd2206cd90e7ffb50302d70df314a99ab2377eb5c816d73" => :high_sierra
    sha256 "3c0918636405335f5d85947322f45e5793f56805f758cf37f3389888a2ca9b15" => :sierra
  end

  head do
    url "https://github.com/bagder/c-ares.git"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-G", "Unix Makefiles", "-DCMAKE_BUILD_TYPE=Release", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"
  end
end
