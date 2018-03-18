class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.hyperscan.io/"
  url "https://github.com/intel/hyperscan/archive/v4.7.0.tar.gz"
  sha256 "a0c07b48ae80903001ab216b03fdf6359bfd5777b2976de728947725b335e941"

  bottle do
    cellar :any
    rebuild 1
    sha256 "55eb18678ce3e28f3a3f79a8ea99d2f7dcbe86083a8f0d97bc117fe375594ed9" => :high_sierra
    sha256 "648f32ad025438523a8199afe341d6a8f90e2ff640261ebcce7ba9b024bd62ff" => :sierra
    sha256 "01355af767aa09859083de0f8fd2b288d0a49cf825ddde73d8e3706a9e86759d" => :el_capitan
  end

  option "with-debug", "Build with debug symbols"

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
