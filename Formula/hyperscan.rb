class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.hyperscan.io/"
  url "https://github.com/intel/hyperscan/archive/v4.7.0.tar.gz"
  sha256 "a0c07b48ae80903001ab216b03fdf6359bfd5777b2976de728947725b335e941"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d3844aae9ce09f30dc639fbbafe18a3d87b2a4fbdea6d8afcc3ef0b3737c79ac" => :high_sierra
    sha256 "683367de58badb15176e183563e19589b22f27efc40317bc7c15829afaf78598" => :sierra
    sha256 "8ec19ac9d6b59c2cee5ea2eb8150825449fd66cc7730d144e124deb6778e6526" => :el_capitan
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
