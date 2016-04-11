class CppNetlib < Formula
  desc "C++ libraries for high level network programming"
  homepage "http://cpp-netlib.org"
  url "http://downloads.cpp-netlib.org/0.12.0/cpp-netlib-0.12.0-final.tar.gz"
  version "0.12.0"
  sha256 "a0a4a5cbb57742464b04268c25b80cc1fc91de8039f7710884bf8d3c060bd711"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "b232d9633fdce290298d9913fe33173c588d910882bb8cac2bd7e2b93b1a4fe3" => :el_capitan
    sha256 "5919b269ee9e442a2d090a40a691bfea9d3d02bca94c94d76054eaa34c883a72" => :yosemite
    sha256 "f9ecd89279b16198bb61424528a88c64d79d023c15e495810f03d39e4aa9c208" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "asio"

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  needs :cxx11

  def install
    ENV.cxx11

    # NB: Do not build examples or tests as they require submodules.
    system "cmake", "-DCPP-NETLIB_BUILD_TESTS=OFF", "-DCPP-NETLIB_BUILD_EXAMPLES=OFF", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <boost/network/protocol/http/client.hpp>
      int main(int argc, char *argv[]) {
        namespace http = boost::network::http;
        http::client::options options;
        http::client client(options);
        http::client::request request("");
        return 0;
      }
    EOS
    flags = [
      "-std=c++11",
      "-stdlib=libc++",
      "-I#{include}",
      "-I#{Formula["asio"].include}",
      "-I#{Formula["boost"].include}",
      "-L#{lib}",
      "-L#{Formula["boost"].lib}",
      "-lssl",
      "-lcrypto",
      "-lboost_system-mt",
      "-lcppnetlib-uri",
      "-lcppnetlib-client-connections",
      "-lcppnetlib-server-parsers",
    ] + ENV.cflags.split
    system ENV.cxx, "-o", "test", "test.cpp", *flags
    system "./test"
  end
end
