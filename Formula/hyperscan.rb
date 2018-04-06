class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.hyperscan.io/"
  url "https://github.com/intel/hyperscan/archive/v4.7.0.tar.gz"
  sha256 "a0c07b48ae80903001ab216b03fdf6359bfd5777b2976de728947725b335e941"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4f6f41fd4dfd25072d895f9f1260d67a8e161530a280d9e0cf47ab53c2464b81" => :high_sierra
    sha256 "8713fa9e91fc1e1a4b88daa6f318e6d4971eeabd5ef5f4aa8d43346d36eaa6bc" => :sierra
    sha256 "307642c835d6c00e2c931409d55920e015769edef314202de0cc7eee45b5dab1" => :el_capitan
  end

  option "with-debug", "Build with debug symbols"
  option "with-ssse3", "Build with SSSE3 for compatibility with older Macs"

  depends_on "python@2" => :build if MacOS.version <= :snow_leopard
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

      if build.with? "ssse3"
        args += %w[
          -DCMAKE_C_FLAGS=-march=core2
          -DCMAKE_CXX_FLAGS=-march=core2
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
