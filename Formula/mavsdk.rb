class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++11"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
    :tag      => "v0.24.0",
    :revision => "38ec5f6ee52190f2e1f6e14e8d371caec5341009"

  bottle do
    cellar :any
    rebuild 1
    sha256 "489268722664d15c833e1cf22f946015859d651d59f84c3fedc76139bf8788d2" => :catalina
    sha256 "f8ed5e00f76d8f18d4a5f4c504e796e9d23a9901adeba6e903815804163c269e" => :mojave
    sha256 "19f9c0f5842cb9d8e14b7740d524e1a4fbfdb29b363872fb9cafe173d721edca" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", *std_cmake_args,
                    "-Bbuild/default",
                    "-DBUILD_BACKEND=ON",
                    "-H."
    system "cmake", "--build", "build/default", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mavsdk/mavsdk.h>
      #include <mavsdk/plugins/info/info.h>
      int main() {
          mavsdk::Mavsdk mavsdk;
          mavsdk.version();
          mavsdk::System& system = mavsdk.system();
          auto info = std::make_shared<mavsdk::Info>(system);
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", testpath/"test.cpp", "-o", "test",
                  "-I#{include}/mavsdk",
                  "-L#{lib}",
                  "-lmavsdk",
                  "-lmavsdk_info"
    system "./test"

    assert_equal "Usage: backend_bin [-h | --help]",
                 shell_output("#{bin}/mavsdk_server --help").split("\n").first
  end
end
