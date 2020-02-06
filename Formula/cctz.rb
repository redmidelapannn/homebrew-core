class Cctz < Formula
  desc "C++ library for translating between absolute and civil times"
  homepage "https://github.com/google/cctz"
  url "https://github.com/google/cctz/archive/v2.3.tar.gz"
  sha256 "8615b20d4e33e02a271c3b93a3b208e3d7d5d66880f5f6208b03426e448f32db"

  bottle do
    cellar :any
    sha256 "3a73ab9d2f67020d95657e8c5b32a26d7eb81987cee2eace2b9d26eab2621bbb" => :catalina
    sha256 "439ce8e6d464aa64aadd117e3effba68379883c3013de4944dda1def4127ff7d" => :mojave
    sha256 "2d61f3555630f98a572971867d5da46212712eb30a18bb6545f9067369865c33" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"

    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", *args
    system "make", "install"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=OFF", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <ctime>
      #include <iostream>
      #include <string>

      std::string format(const std::string& fmt, const std::tm& tm) {
        char buf[100];
        std::strftime(buf, sizeof(buf), fmt.c_str(), &tm);
        return buf;
      }

      int main() {
        const std::time_t now = std::time(nullptr);
        std::tm tm_utc, tm_local;

      #if defined(_WIN32) || defined(_WIN64)
        gmtime_s(&tm_utc, &now);
        localtime_s(&tm_local, &now);
      #else
        gmtime_r(&now, &tm_utc);
        localtime_r(&now, &tm_local);
      #endif
        std::cout << format("UTC: %Y-%m-%d %H:%M:%S\\n", tm_utc) << format("Local: %Y-%m-%d %H:%M:%S\\n", tm_local);
      }
    EOS
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lcctz", "test.cc", "-o", "test"
    system testpath/"test"
  end
end
