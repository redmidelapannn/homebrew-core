class Libevhtp < Formula
  desc "Create extremely-fast and secure embedded HTTP servers with ease"
  homepage "https://github.com/criticalstack/libevhtp"
  url "https://github.com/criticalstack/libevhtp/archive/1.2.18.tar.gz"
  sha256 "316ede0d672be3ae6fe489d4ac1c8c53a1db7d4fe05edaff3c7c853933e02795"

  bottle do
    cellar :any_skip_relocation
    sha256 "74d50f2905b0a73d307aac31ffb34d201880ce1020921c60fdaad33dc1039b02" => :mojave
    sha256 "8ba1335864b5df651d71880287f2e123bbaa50d75f60c3fa35b2b956bc3d39cf" => :high_sierra
    sha256 "791e423a3d4616a80d1694b9f54b03aa1403864ba0a2108da910cd8519620af1" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libevent"
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    mkdir_p "./html/docs/"
    system "doxygen", "Doxyfile"
    man3.install Dir["html/docs/man/man3/*.3"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <evhtp.h>
      int main() {
        struct event_base *evbase;
        struct evhtp *htp;
        evbase = event_base_new();
        htp = evhtp_new(evbase, NULL);
        evhtp_free(htp);
        event_base_free(evbase);
        return 0;
      }
    EOS
    system ENV.cc, "test.c",
      "-L#{lib}", "-L#{Formula["libevent"].opt_lib}", "-L#{Formula["openssl"].opt_lib}",
      "-I#{Formula["openssl"].opt_include}",
      "-levent", "-levent_openssl", "-levhtp", "-lssl", "-lcrypto",
      "-o", "test"
    system "./test"
  end
end
