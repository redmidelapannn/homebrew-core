class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.10/pugixml-1.10.tar.gz"
  sha256 "55f399fbb470942410d348584dc953bcaec926415d3462f471ef350f29b5870a"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b0d0425ff5d1dc08aaa9a258ceba8c89fda7dd0e1c5060f31649a263f7b28a8" => :mojave
    sha256 "16ca87a0cb6f48344137eb1e9eae6bf727028e4b0985c2487669cb0bf98ca68f" => :high_sierra
    sha256 "fd46cd11c272c55a0640b35a05518891d80fdd1d61bc2d2e484ad352f7ca2a3d" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=OFF",
                         "-DBUILD_PKGCONFIG=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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

    (testpath/"test.xml").write <<~EOS
      <root>Hello world!</root>
    EOS

    system ENV.cc, "test.cpp", "-o", "test", "-lstdc++",
           "-I#{include}", "-L#{lib}", "-lpugixml"
    system "./test"
  end
end
