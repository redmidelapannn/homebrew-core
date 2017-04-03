class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.11.3.1.tar.gz"
  sha256 "8679724bf818804c529810a9603b74d30a11d46a8f724610e4ee3c1ff47eda9f"

  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "9a34b62fb27cc10aa1194b1b3ea66ad2b7e6bad9e8bfdc982af1d62db69d58d3" => :sierra
    sha256 "59e0132fe9548df30c275d621af0ab25a0a0b2d30fb389bd12e4f08ce67af7fd" => :el_capitan
    sha256 "e67a6236cac7907cd7c6370bacb5150fe9428737ff4c24b617f9c29fcd430e89" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  def install
    mkdir "build" do
      system "cmake", "../cmake", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <stdlib.h>
      #include <Gosu/Gosu.hpp>

      class MyWindow : public Gosu::Window
      {
      public:
          MyWindow()
          :   Gosu::Window(640, 480)
          {
              set_caption(\"Hello World!\");
          }

          void update()
          {
              exit(0);
          }
      };

      int main()
      {
          MyWindow window;
          window.show();
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lgosu", "-I#{include}", "-std=c++11"
    system "./test"
  end
end
