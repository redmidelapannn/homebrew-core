class KyotoCabinet < Formula
  desc "Library of routines for managing a database"
  homepage "https://fallabs.com/kyotocabinet/"
  url "https://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.76.tar.gz"
  sha256 "812a2d3f29c351db4c6f1ff29d94d7135f9e601d7cc1872ec1d7eed381d0d23c"

  bottle do
    rebuild 1
    sha256 "8d7841a1f1ab81bea099df3c07ba9c7d10da368918fc3ab3ecdc2bba58f78017" => :mojave
    sha256 "d787df87c4b6824e5c79d8eb737741a389fc7f47219388cfea4c46e33fab9da5" => :high_sierra
    sha256 "ca2b4ec91410c09519ef8fd2d559fb287204962467c91cdb1e4a67c549671e09" => :sierra
  end

  patch :DATA

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make", "install"
  end
end


__END__
--- a/kccommon.h  2013-11-08 09:27:37.000000000 -0500
+++ b/kccommon.h  2013-11-08 09:27:47.000000000 -0500
@@ -82,7 +82,7 @@
 using ::snprintf;
 }

-#if __cplusplus > 199711L || defined(__GXX_EXPERIMENTAL_CXX0X__) || defined(_MSC_VER)
+#if __cplusplus > 199711L || defined(__GXX_EXPERIMENTAL_CXX0X__) || defined(_MSC_VER) || defined(_LIBCPP_VERSION)

 #include <unordered_map>
 #include <unordered_set>
