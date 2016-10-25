class Wdc < Formula
  desc "WebDAV Client provides easy and convenient to work with WebDAV-servers."
  homepage "https://designerror.github.io/webdav-client-cpp"
  url "https://github.com/designerror/webdav-client-cpp/archive/v1.0.0.tar.gz"
  sha256 "649a75a7fe3219dff014bf8d98f593f18d3c17b638753aa78741ee493519413d"

  bottle do
    cellar :any_skip_relocation
    sha256 "416ca2d7be784b8d6eff2e3f0b06183b85d4fa5db248bd808704710e74feb061" => :sierra
    sha256 "8042c402b02bf8d26d088479859e9099d846a6747f07897ded12d8896a30f7c9" => :el_capitan
    sha256 "c1d2d73054abae0f6829e84df3c2e253dfecfa751a9c5a91aecd6b04bf3d9607" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "pugixml"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    (lib+"pkgconfig/libwebdavclient.pc").write pc_file
  end

  def pc_file; <<-EOS.undent
    prefix=#{HOMEBREW_PREFIX}
    exec_prefix=${prefix}
    libdir=${exec_prefix}/lib
    includedir=${exec_prefix}/include
    Name: libwebdavclient
    Description: Modern and convenient C++ WebDAV Client library
    Version: 1.0.0
    Libs: -L${libdir} -lwebdavclient
    Libs.private: -lpthread -lpugixml -lm -lcurl -lssl -lcrypto
    Cflags: -I${includedir}
    EOS
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <webdav/client.hpp>
      #include <cassert>
      #include <string>
      #include <memory>
      #include <map>
      int main(int argc, char *argv[]) {
        std::map<std::string, std::string> options =
        {
          {"webdav_hostname", "https://webdav.example.com"},
          {"webdav_login",    "webdav_login"},
          {"webdav_password", "webdav_password"}
        };
        std::shared_ptr<WebDAV::Client> client(WebDAV::Client::Init(options));
        auto check_connection = client->check();
        assert(!check_connection);
      }
    EOS
    system ENV.cc,  "test.cpp", "-L#{lib}", "-L/usr/local/lib",
                    "-lwebdavclient", "-lpthread", "-lpugixml",
                    "-lm", "-lcurl", "-lssl", "-lcrypto",
                    "-lstdc++", "-std=c++11", "-o", "test"
    system "./test"
  end
end
