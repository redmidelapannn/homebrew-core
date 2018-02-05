class Microws < Formula
  desc "Tiny WebSockets"
  homepage "https://github.com/uNetworking/uWebSockets"
  url "https://github.com/uNetworking/uWebSockets/archive/v0.14.5.tar.gz"
  sha256 "4e4a4bcde543baae57ca8f327304874d1bb1fb11b2c4f71618d2b3279003f2d5"

  bottle do
    cellar :any
    sha256 "3e68aa1eed2f97fddc5aa7c0e088ae39a073ad17e606e812d8cc3af365334d98" => :high_sierra
    sha256 "6bb838d1b0ffa36069dd409b88259c4b431c6b895a4dcc5fbbecec76f386021e" => :sierra
    sha256 "2099f239114511ff36411bed4508ee9dd739b78ab70ddb9d1038553228481610" => :el_capitan
  end

  depends_on "libuv"
  depends_on "openssl"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <uWS/uWS.h>

      int main()
      {
          uWS::Hub h;

          h.onMessage([](uWS::WebSocket<uWS::SERVER> *ws, char *message, size_t length, uWS::OpCode opCode) {
              ws->send(message, length, opCode);
          });

          if (h.listen(3000)) {
            exit(0);
          } else {
            exit(1);
          }
      }
    EOS
    system ENV.cxx, "--std=c++14",
                    "-I#{Formula["openssl"].opt_include}", "-L#{Formula["openssl"].opt_lib}", "-lssl",
                    "-I#{include}", "-L#{lib}", "-luws",
                    "-I#{Formula["libuv"].opt_include}", "-L#{Formula["libuv"].opt_lib}", "-luv",
                    "-lz", "test.cpp", "-o", "test"
    system "./test"
  end
end
