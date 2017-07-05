class Globjects < Formula
  desc "C++ library strictly wrapping OpenGL objects"
  homepage "https://github.com/cginternals/globjects"
  url "https://github.com/cginternals/globjects/archive/v1.0.0.tar.gz"
  sha256 "be2f95b4e98eef61a57925985735af266fef667eec63a39f65def5d5d808a30a"
  revision 1
  head "https://github.com/cginternals/globjects.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f2c4644faf85ae3846a3b2bd5b863b867185936361e3f5cbb5a078ac83b0d8e8" => :sierra
    sha256 "aba7be6f086055a04edfc35c574fa257f79304de0f78789092520204a1f9a621" => :el_capitan
    sha256 "7419fe050998a808bf4814b526fed8e5020a9186a6cfa3423b17b37a21622218" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "glm"
  depends_on "glbinding"

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", "-Dglbinding_DIR=#{Formula["glbinding"].opt_prefix}", *std_cmake_args
    system "cmake", "--build", ".", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <globjects/globjects.h>
      int main(void)
      {
        globjects::init();
      }
      EOS
    system ENV.cxx, "-o", "test", "test.cpp", "-std=c++11", "-stdlib=libc++",
           "-I#{include}/globjects", "-I#{Formula["glm"].include}/glm", "-I#{lib}/globjects",
           "-L#{lib}", "-lglobjects", "-lglbinding", *ENV.cflags.to_s.split
    system "./test"
  end
end
