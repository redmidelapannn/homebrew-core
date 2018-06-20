class Uwebsockets < Formula
  desc "Tiny WebSockets"
  homepage "https://gitlab.com/uNetworking/uWebSockets/"
  url "https://github.com/uNetworking/uWebSockets/archive/v0.14.8.tar.gz"
  sha256 "663a22b521c8258e215e34e01c7fcdbbd500296aab2c31d36857228424bb7675"

  bottle do
    cellar :any
    sha256 "4fe716126c4367e07cc050cf1e7bbbf113818bdf5699fe0566c50f302bdf8de4" => :high_sierra
    sha256 "2e2023dee5c8ae2e2186c5f2cc123dd22fa6bd713ef66748def0688c926436a3" => :sierra
    sha256 "6b3fe77626cf75e0aa10e0f7cb725800ad8fe75ac9d646f3d6cc3937d8e4fb5a" => :el_capitan
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
      int main() {
          uWS::Hub h;
          h.run();
      }
    EOS
    system ENV.cxx, "-std=c++11",
                    "-I#{Formula["openssl"].opt_include}",
                    "-L#{Formula["openssl"].opt_lib}", "-lssl",
                    "-I#{include}", "-L#{lib}", "-luws",
                    "-I#{Formula["libuv"].opt_include}",
                    "-L#{Formula["libuv"].opt_lib}", "-luv",
                    "-lz", "test.cpp", "-o", "test"
    system "./test"
  end
end
