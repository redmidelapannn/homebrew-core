class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "http://pugixml.org"
  url "https://github.com/zeux/pugixml/releases/download/v1.8.1/pugixml-1.8.1.tar.gz"
  sha256 "00d974a1308e85ca0677a981adc1b2855cb060923181053fb0abf4e2f37b8f39"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d65134410e2d6938d9b90d06f5edd0215713be4fd11abfc83c11260ba4a9e289" => :sierra
    sha256 "9912602e93da4689423e5b6cc70b56a2dcf34cca165062aed8f7bf5d871e94ee" => :el_capitan
    sha256 "25fdb90eba35caac0ea2d37b4c19e8c717ddf8b23c3cf66e13ba1116010d9c6e" => :yosemite
  end

  option "with-shared", "Build shared instead of static library"

  depends_on "cmake" => :build

  def install
    shared = build.with?("shared") ? "ON" : "OFF"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=#{shared}",
                         "-DBUILD_PKGCONFIG=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <pugixml.hpp>
      #include <cassert>
      #include <cstring>

      int main(int argc, char *argv[]) {
        pugi::xml_document doc;
        pugi::xml_parse_result result = doc.load_file("test.xml");

        assert(result);
        assert(strcmp(doc.child_value("root"), "Hello world!") == 0);
      }
    EOS

    (testpath/"test.xml").write <<-EOS.undent
      <root>Hello world!</root>
    EOS

    system ENV.cc, "test.cpp", "-o", "test", "-lstdc++",
                               "-L#{Dir["#{lib}/pug*"].first}", "-lpugixml",
                               "-I#{include.children.first}"
    system "./test"
  end
end
