class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.9.1.tar.gz"
  sha256 "c7b40f5605dd972108f503f031b20186f5e5bca2b65cd4b8bd6c3e4ba8126697"
  head "https://github.com/open-source-parsers/jsoncpp.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4432abd4fe4b702b4664bc61f2e3307237fff772e7ac83fcb420c8f7fef0f949" => :mojave
    sha256 "0cce0ec435652f6a3c96673cfd5fec9e14e7c361d4783c9d8389f068d14e7df4" => :high_sierra
    sha256 "f4e0098b3e6e1381119b05535b918127da1d90549e86c2b4697bab8bfd48e3ab" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <json/json.h>
      int main() {
          Json::Value root;
          Json::CharReaderBuilder builder;
          std::string errs;
          std::istringstream stream1;
          stream1.str("[1, 2, 3]");
          return Json::parseFromStream(builder, stream1, &root, &errs) ? 0: 1;
      }
    EOS
    system ENV.cxx, "-std=c++11", testpath/"test.cpp", "-o", "test",
                  "-I#{include}/jsoncpp",
                  "-L#{lib}",
                  "-ljsoncpp"
    system "./test"
  end
end
