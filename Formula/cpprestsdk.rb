class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/Microsoft/cpprestsdk"
  url "https://github.com/Microsoft/cpprestsdk/archive/v2.10.2.tar.gz"
  sha256 "fb0b611007732d8de9528bc37bd67468e7ef371672f89c88f225f73cdc4ffcf1"

  head "https://github.com/Microsoft/cpprestsdk.git", :branch => "development"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c3d31fc357f4ec07124ad7bbfd35f514f4b8aecbf324723aca7993f8844fa374" => :high_sierra
    sha256 "756da2fd4f8028d490a28ab88cd920a24a4cb8cf531b3e396ea5265c6a614305" => :sierra
    sha256 "85f2d84333d383268a299747d9f6798b4e2cf9c7f0450c7a9c50144e373c139b" => :el_capitan
  end

  depends_on "boost"
  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    system "cmake", "-DBUILD_SAMPLES=OFF", "-DBUILD_TESTS=OFF", "Release", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <cpprest/http_client.h>
      int main() {
        web::http::client::http_client client(U("https://github.com/"));
        std::cout << client.request(web::http::methods::GET).get().extract_string().get() << std::endl;
      }
    EOS
    flags = ["-stdlib=libc++", "-std=c++11", "-I#{include}",
             "-I#{Formula["boost"].include}",
             "-I#{Formula["openssl"].include}", "-L#{lib}",
             "-L#{Formula["openssl"].lib}", "-L#{Formula["boost"].lib}",
             "-lssl", "-lcrypto", "-lboost_random", "-lboost_chrono",
             "-lboost_thread-mt", "-lboost_system-mt", "-lboost_regex",
             "-lboost_filesystem", "-lcpprest"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test_cpprest", "test.cc", *flags
    system "./test_cpprest"
  end
end
