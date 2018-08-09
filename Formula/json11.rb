class Json11 < Formula
  desc "Tiny JSON library for C++11"
  homepage "https://github.com/dropbox/json11"
  url "https://github.com/dropbox/json11.git", :revision => "ec4e45219af1d7cde3d58b49ed762376fccf1ace"
  version "1.0.0"
  bottle do
    cellar :any_skip_relocation
    sha256 "46d76a391c03ba45077e9e548223aecff07ed199de36e1b1098878c9902693ac" => :high_sierra
    sha256 "2d0b38f14adec139276df06b29de752ab34d5ea45fd61c6a6ca6af6e52d60c50" => :sierra
    sha256 "4d4c6377a1ca43cf240bf0855b5d8755599951f07e3d1d5bad03f07b395f0416" => :el_capitan
  end

  depends_on "cmake" => :build
  needs :cxx11

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <json11.hpp>
      #include <string>
      using namespace json11;

      int main() {
        Json my_json = Json::object {
          { "key1", "value1" },
          { "key2", false },
          { "key3", Json::array { 1, 2, 3 } },
        };
        auto json_str = my_json.dump();
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-ljson11", "-o", "test"
    system "./test"
  end
end
