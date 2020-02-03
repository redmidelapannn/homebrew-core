class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.9.2.tar.gz"
  sha256 "77a402fb577b2e0e5d0bdc1cf9c65278915cdb25171e3452c68b6da8a561f8f0"
  head "https://github.com/open-source-parsers/jsoncpp.git"

  bottle do
    cellar :any
    sha256 "0653667773ccab9cecc305d679b9f6958fb683f5e9f0c900b1ff5a59f8224f84" => :catalina
    sha256 "420677899bb59b486b53089af251819c78886f19df24fe5dbef6a034c044f396" => :mojave
    sha256 "a0812f33a3d563d6665a4bd96ea5f0a74e48630b746044ee5030b235839b3759" => :high_sierra
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
