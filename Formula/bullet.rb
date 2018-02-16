class Bullet < Formula
  desc "Physics SDK"
  homepage "http://bulletphysics.org/wordpress/"
  url "https://github.com/bulletphysics/bullet3/archive/2.87.tar.gz"
  sha256 "438c151c48840fe3f902ec260d9496f8beb26dba4b17769a4a53212903935f95"
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9d862a27e87704e47004d69e6b169b80acac3f3ee3bec9ece411ae9a1d6a5bd4" => :high_sierra
    sha256 "ad29e478763de05c8dfa9607384c19953687af28c29f3a33b63781bc0127decd" => :sierra
    sha256 "84d40d3e9c4d66815ac3d33ce1aa690e5687fa677594f4b2680b20e75a9e709a" => :el_capitan
  end

  option "with-framework", "Build frameworks"
  option "with-demo", "Build demo applications"
  option "with-double-precision", "Use double precision"

  deprecated_option "framework" => "with-framework"
  deprecated_option "build-demo" => "with-demo"
  deprecated_option "double-precision" => "with-double-precision"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %w[
      -DINSTALL_EXTRA_LIBS=ON -DBUILD_UNIT_TESTS=OFF -DBUILD_PYBULLET=OFF
    ]
    args << "-DUSE_DOUBLE_PRECISION=ON" if build.with? "double-precision"

    args_shared = args.dup + %w[
      -DBUILD_BULLET2_DEMOS=OFF -DBUILD_SHARED_LIBS=ON
    ]

    args_framework = %W[
      -DFRAMEWORK=ON
      -DCMAKE_INSTALL_PREFIX=#{frameworks}
      -DCMAKE_INSTALL_NAME_DIR=#{frameworks}
    ]

    args_shared += args_framework if build.with? "framework"

    args_static = args.dup << "-DBUILD_SHARED_LIBS=OFF"
    if build.without? "demo"
      args_static << "-DBUILD_BULLET2_DEMOS=OFF"
    else
      args_static << "-DBUILD_BULLET2_DEMOS=ON"
    end

    mkdir "build" do
      system "cmake", "..", *args_shared
      system "make", "install"

      system "make", "clean"

      system "cmake", "..", *args_static
      system "make", "install"

      if build.with? "demo"
        rm_rf Dir["examples/**/Makefile", "examples/**/*.cmake", "examples/**/CMakeFiles"]
        pkgshare.install "examples"
        (pkgshare/"examples").install "../data"
      end
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "LinearMath/btPolarDecomposition.h"
      int main() {
        btMatrix3x3 I = btMatrix3x3::getIdentity();
        btMatrix3x3 u, h;
        polarDecompose(I, u, h);
        return 0;
      }
    EOS

    if build.with? "framework"
      system ENV.cc, "test.cpp", "-F#{frameworks}", "-framework", "LinearMath",
                     "-I#{frameworks}/LinearMath.framework/Headers", "-lc++",
                     "-o", "f_test"
      system "./f_test"
    end

    system ENV.cc, "test.cpp", "-I#{include}/bullet", "-L#{lib}",
                   "-lLinearMath", "-lc++", "-o", "test"
    system "./test"
  end
end
