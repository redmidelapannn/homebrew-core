class Zmqpp < Formula
  desc "High-level C++ binding for zeromq"
  homepage "https://zeromq.github.io/zmqpp/"
  url "https://github.com/zeromq/zmqpp/archive/4.2.0.tar.gz"
  sha256 "c1d4587df3562f73849d9e5f8c932ca7dcfc7d8bec31f62d7f35073ef81f4d29"

  bottle do
    cellar :any
    sha256 "45ed9cec30d14c2f0425e659ad453771c1eb16b4f2bc97e8cf2c97b108c38dc1" => :high_sierra
    sha256 "6cd10a451b42ef20a2c991f7af23f355efe82e4bf4371c12d239a00077848e34" => :sierra
    sha256 "a4b141ce1b06b7d050567021d5b136a509978f18e339798829550dc3ba1baef6" => :el_capitan
  end

  depends_on "zeromq"

  needs :cxx11

  def install
    ENV.cxx11
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <zmqpp/zmqpp.hpp>
      int main() {
        zmqpp::frame frame;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzmqpp", "-o", "test", "-std=c++11", "-stdlib=libc++", "-lc++"
    system "./test"
  end
end
