class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/0.7.7.tar.gz"
  sha256 "7e6d9d4d9ec24fa4227655158c9d382f6b1910f8ef78f5bcfc9f5bafe155836d"
  revision 1

  bottle do
    cellar :any
    sha256 "62f5bbd6ec174d6ac3a5f120338a494aefb5151f8d45fe052b0fe9be3691d469" => :high_sierra
    sha256 "fd113022ae7fef0b5d9efaef958bb833ae24f15ce2ca3184c0dc9d3d0a5aa674" => :sierra
    sha256 "b0900290f302d63b1fb390654af50f503d6da362a4b2886babae4de36ac728d6" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <TGUI/TGUI.hpp>
      int main()
      {
        sf::Text text;
        text.setString("Hello World");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-I#{include}",
      "-L#{lib}", "-L#{Formula["sfml"].opt_lib}",
      "-ltgui", "-lsfml-graphics", "-lsfml-system", "-lsfml-window",
      "-o", "test"
    system "./test"
  end
end
