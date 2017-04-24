class Bullet < Formula
  desc "Physics SDK"
  homepage "http://bulletphysics.org/wordpress/"
  url "https://github.com/bulletphysics/bullet3/archive/2.86.1.tar.gz"
  sha256 "c058b2e4321ba6adaa656976c1a138c07b18fc03b29f5b82880d5d8228fbf059"
  revision 1

  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "efdd2f02421a95c3a399962081ad5209f100825fd1c675e25b4d96693ef9252d" => :sierra
    sha256 "1aab6c634c6f175667f5e71a2d4221be160decb50b96f7d70e001f5fb495d433" => :el_capitan
    sha256 "71dcb0c8432c3d066bf349c8501f22c30d9ef179115cf4ed93422e75827dcef9" => :yosemite
  end

  option "with-framework", "Build frameworks"
  option "with-demo", "Build demo applications"
  option "with-double-precision", "Use double precision"

  deprecated_option "framework" => "with-framework"
  deprecated_option "build-demo" => "with-demo"
  deprecated_option "double-precision" => "with-double-precision"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] }
    args << "-DINSTALL_EXTRA_LIBS=ON" << "-DBUILD_UNIT_TESTS=OFF"

    if build.with? "framework"
      args << "-DFRAMEWORK=ON"
      args << "-DCMAKE_INSTALL_PREFIX=#{frameworks}"
      args << "-DCMAKE_INSTALL_NAME_DIR=#{frameworks}"
      args << "-DBUILD_BULLET2_DEMOS=OFF"
    else
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
      args << "-DBUILD_BULLET2_DEMOS=OFF" if build.without? "demo"
    end

    args << "-DUSE_DOUBLE_PRECISION=ON" if build.with? "double-precision"

    # always build and install shared libraries
    system "cmake", *args, "-DBUILD_SHARED_LIBS=ON"
    system "make"
    system "make", "install"

    # build static libraries if it's not a framework
    if build.without? "framework"
      system "cmake", *args, "-DBUILD_SHARED_LIBS=OFF"
      system "make"
      system "make", "install"

      # examples and extras only work with static libraries
      prefix.install "examples" if build.with? "demo"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "bullet/LinearMath/btPolarDecomposition.h"
      int main() {
        btMatrix3x3 I = btMatrix3x3::getIdentity();
        btMatrix3x3 u, h;
        polarDecompose(I, u, h);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lLinearMath", "-lc++", "-o", "test"
    system "./test"
  end
end
