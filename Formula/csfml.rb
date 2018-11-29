class Csfml < Formula
  # Don't update CSFML until there's a corresponding SFML release
  desc "SMFL bindings for C"
  homepage "https://www.sfml-dev.org/"
  url "https://github.com/SFML/CSFML/archive/2.5.tar.gz"
  sha256 "ccf38b057f3c306a731edc4e9e5b41a0f06105a4ea624ff42868c5b31983720e"
  head "https://github.com/SFML/CSFML.git"

  bottle do
    cellar :any
    sha256 "58c9a9a19d4fa0f86cef4706764bd6a0679a7e141e997627c3a6bed0140babe1" => :mojave
    sha256 "dd6db626d445d2c808f9ce77184ea38f3983948adc333ef9e419722b9eac6629" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    system "cmake", ".", "-DCMAKE_MODULE_PATH=#{Formula["sfml"].share}/SFML/cmake/Modules/", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SFML/Window.h>

      int main (void)
      {
        sfWindow * w = sfWindow_create (sfVideoMode_getDesktopMode (), "Test", 0, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcsfml-window", "-o", "test"
    system "./test"
  end
end
