class LibjdcloudSigner < Formula
  desc "C++ signing library for jdcloud.com"
  homepage "https://github.com/jdcloud-api/jdcloud-sdk-cpp-signer"
  url "https://github.com/jdcloud-api/jdcloud-sdk-cpp-signer/archive/v0.2.0.tar.gz"
  sha256 "f78ac6cfc8bdf539eaca11f13966671e38749feb46abac57db36bb24a8d12e36"
  head "https://github.com/jdcloud-api/jdcloud-sdk-cpp-signer.git"

  bottle do
    cellar :any
    sha256 "c1eb331f810dfef4892ef86fe6b01f3082b3e33ec9628749a3bed6f97f0b8051" => :mojave
    sha256 "c154916eb302b7258f7ffae9a03fa055d4ac3931d4c4d27d08d8f59aeee44ed5" => :high_sierra
    sha256 "c9d4ca9693cb250de40f57843a1c11c957b7ba28ef3b8b80255adb289f9ff939" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    system "cmake", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}", "."
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <jdcloud_signer/JdcloudSigner.h>
      using namespace jdcloud_signer;
      int main() {
        Credential credential("AK", "SK");
        JdcloudSigner signer(credential, "vm", "cn-north-1");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-ljdcloud_signer"
    system "./test"
  end
end
