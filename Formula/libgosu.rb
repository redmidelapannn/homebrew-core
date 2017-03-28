class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.11.3.1.tar.gz"
  sha256 "8679724bf818804c529810a9603b74d30a11d46a8f724610e4ee3c1ff47eda9f"

  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "723e202d0b675d45a63cff4ad3a2be792e1ad0162cf88e31023984bf0f899028" => :sierra
    sha256 "6b9efc66977e3d5e846d2e9ac720de715789105c9c7a5b5d82f54bbf05d1fc5e" => :el_capitan
    sha256 "e51481c74db2aa38388fd0712f611db377be3b21cc21b2e182180284ffa6aef5" => :yosemite
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
