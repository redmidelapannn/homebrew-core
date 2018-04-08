class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.hyperscan.io/"
  url "https://github.com/intel/hyperscan/archive/v4.7.0.tar.gz"
  sha256 "a0c07b48ae80903001ab216b03fdf6359bfd5777b2976de728947725b335e941"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2461e92b568223e668cc2b95a767463767b00c4242ac3cae4500068b0868ee89" => :high_sierra
    sha256 "b4490afa2cf0b4e5a9ffa167aaeb3fdf768495fa0e86d0dda67445c069b8ce96" => :sierra
    sha256 "4df6ec67bc6bc6e4ab7756d6c6907ea296b346ba8d2103b1385dff93e1a646d1" => :el_capitan
  end

  option "with-debug", "Build with debug symbols"

  depends_on "python@2" => :build
  depends_on "boost" => :build
  depends_on "ragel" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    mkdir "build" do
      args = std_cmake_args << "-DBUILD_STATIC_AND_SHARED=on"

      if build.with? "debug"
        args -= %w[
          -DCMAKE_BUILD_TYPE=Release
          -DCMAKE_C_FLAGS_RELEASE=-DNDEBUG
          -DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG
        ]
        args += %w[
          -DCMAKE_BUILD_TYPE=Debug
          -DDEBUG_OUTPUT=on
        ]
      end

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <hs/hs.h>
      int main()
      {
        printf("hyperscan v%s", hs_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lhs", "-o", "test"
    system "./test"
  end
end
