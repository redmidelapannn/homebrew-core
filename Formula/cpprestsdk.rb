class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/Microsoft/cpprestsdk"
  # pull from git tag to get submodules
  url "https://github.com/Microsoft/cpprestsdk.git",
      :tag      => "v2.10.14",
      :revision => "6f602bee67b088a299d7901534af3bce6334ab38"
  revision 1
  head "https://github.com/Microsoft/cpprestsdk.git", :branch => "development"

  bottle do
    cellar :any
    rebuild 1
    sha256 "619d287fc02b9bf87853fb028004c3b48cd9cfdd074e32cdbaedf3556d95d52a" => :catalina
    sha256 "20251528e0c98dd449fbdd87a479892970730a54b102508a02ab0c77f63bea6a" => :mojave
    sha256 "6b2ea8176ffdad15ded34a030c605bd1aa63c5b19f5df1857dcfe5a2082d04af" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@1.1"

  # Fix for boost 1.70.0 https://github.com/microsoft/cpprestsdk/issues/1054
  # From websocketpp pull request https://github.com/zaphoyd/websocketpp/pull/814
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/cpprestsdk/2.10.14.diff"
    sha256 "fdfd1d6c3108bd463f3a6e3c8056a4f82268d6def1867b5fbbd9682f617c8c25"
  end

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
             "-I#{Formula["openssl@1.1"].include}", "-L#{lib}",
             "-L#{Formula["openssl@1.1"].lib}", "-L#{Formula["boost"].lib}",
             "-lssl", "-lcrypto", "-lboost_random", "-lboost_chrono",
             "-lboost_thread-mt", "-lboost_system-mt", "-lboost_regex",
             "-lboost_filesystem", "-lcpprest"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test_cpprest", "test.cc", *flags
    system "./test_cpprest"
  end
end
