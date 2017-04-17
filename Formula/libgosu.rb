class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.11.3.1.tar.gz"
  sha256 "8679724bf818804c529810a9603b74d30a11d46a8f724610e4ee3c1ff47eda9f"

  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "c8a6b8364b3db53a5ae63f37d2f003143677ff0f42df6e0abc4090933367db19" => :sierra
    sha256 "0843c47618e7665ed58f355daad1f46b98641d38dc08e0295d35b5f88b58c262" => :el_capitan
    sha256 "6701410d56d88468b2f822767ce82151568756440d45f03dc33d0aff3e2e63be" => :yosemite
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
