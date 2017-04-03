class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.11.3.1.tar.gz"
  sha256 "8679724bf818804c529810a9603b74d30a11d46a8f724610e4ee3c1ff47eda9f"

  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "cbe79b625ff501e7c52358b1b965c8bff276384e01d5c171a39f0897b09b009f" => :sierra
    sha256 "33fbe99b60eeb491b4245d0f475abe3a4ea4e9e94b364a810ca969d164a963a1" => :el_capitan
    sha256 "295d47d2ffb84cb76301bfa452e53dc0e1333412434b6b1c8887a6531c51a820" => :yosemite
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
