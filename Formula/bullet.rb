class Bullet < Formula
  desc "Physics SDK"
  homepage "http://bulletphysics.org/wordpress/"
  url "https://github.com/bulletphysics/bullet3/archive/2.86.1.tar.gz"
  sha256 "c058b2e4321ba6adaa656976c1a138c07b18fc03b29f5b82880d5d8228fbf059"
  revision 1

  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b7f40d409763c32904254ee2d6f5178d8bd47793e3f2fbe2f1c760a9ceb62f65" => :sierra
    sha256 "8627b53da6c0bdc74e0ebde07c475262f5707b7fb02675f4669aca61c3eab852" => :el_capitan
    sha256 "b513f97f3d7344c047806e6316739f987c63c947a949914ddbd9e3a07674f43b" => :yosemite
  end

  option "with-framework", "Build frameworks"
  option "with-demo", "Build demo applications"
  option "with-double-precision", "Use double precision"

  deprecated_option "framework" => "with-framework"
  deprecated_option "build-demo" => "with-demo"
  deprecated_option "double-precision" => "with-double-precision"

  depends_on "cmake" => :build
  depends_on "enet" => :recommended
  depends_on :python => :recommended
  depends_on "numpy" => :recommended

  def install
    args = std_cmake_args + %w[
      -DINSTALL_EXTRA_LIBS=ON -DBUILD_UNIT_TESTS=OFF
    ]
    args << "-DUSE_DOUBLE_PRECISION=ON" if build.with? "double-precision"
    args << "-DBUILD_BULLET2_DEMOS=ON" if build.with? "demo"
    args << "-DBUILD_BULLET2_DEMOS=OFF" if build.without? "demo"

    if build.with? "python"
      args += %W[
        -DBUILD_PYBULLET=ON
        -DBUILD_PYBULLET_NUMPY=ON
        -DBUILD_PYBULLET_CLSOCKET=ON
        -DBUILD_PYBULLET_ENET=ON
      ]
    end

    if build.with? "enet"
      args += %W[
        -DBUILD_ENET=ON
        -DBUILD_CLSOCKET=ON
      ]
    end
    args_shared = args.dup + %w[
      -DBUILD_SHARED_LIBS=ON
    ]

    args_framework = %W[
      -DFRAMEWORK=ON
      -DCMAKE_INSTALL_PREFIX=#{frameworks}
      -DCMAKE_INSTALL_NAME_DIR=#{frameworks}
    ]

    args_shared += args_framework if build.with? "framework"

    args_static = args.dup << "-DBUILD_SHARED_LIBS=OFF"
    args_static << "-DBUILD_BULLET2_DEMOS=OFF"

    mkdir "build_cmake_static" do
      puts "cmake", "..", *args_static
      system "cmake", "..", *args_static
      system "make", "install", "VERBOSE=1"
    end

    mkdir "build_cmake_shared" do
      puts "cmake", "..", *args_shared
      system "cmake", "..", *args_shared
      system "make", "install", "VERBOSE=1"
    end

    if build.with? "demo"
      prefix.install "build_cmake"
      prefix.install "data"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
