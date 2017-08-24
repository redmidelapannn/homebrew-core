class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.8.1/pugixml-1.8.1.tar.gz"
  sha256 "00d974a1308e85ca0677a981adc1b2855cb060923181053fb0abf4e2f37b8f39"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bc4befa9bc87168d49e29d9191b97b48bbed663ec85a8b3177e5385a869f3590" => :sierra
    sha256 "a6291e160f5e5e8484335264ca2995649bfbbabcab2f2ad2789bc7a5497f7148" => :el_capitan
    sha256 "86975abc90690d83f76a879fd4791202ad3e7c47727412659a03e722b43f4965" => :yosemite
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
