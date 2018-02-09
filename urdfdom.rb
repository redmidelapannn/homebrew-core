class Urdfdom < Formula
  desc "URDF parser"
  homepage "https://wiki.ros.org/urdf"
  url "https://github.com/ros/urdfdom/archive/1.0.0.tar.gz"
  sha256 "243ea925d434ebde0f9dee35ee5615ecc2c16151834713a01f85b97ac25991e1"

  depends_on "cmake" => :build
  depends_on "tinyxml"
  depends_on "console_bridge"
  depends_on "urdfdom_headers"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fstream>
      #include <iostream>
      #include <urdf_parser/urdf_parser.h>
      int main() {
        std::string xml_string = 
          "<robot name=\"testRobot\">\n"
          "  <link name=\"link_0\">  \n"
          "  </link>                 \n"
          "</robot">                   ";
        urdf::parseURDF(xml_string);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lc++", "-std=c++11", "-o", "test"
    system "./test"
  end
end
