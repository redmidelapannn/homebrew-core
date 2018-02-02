class Libksi < Formula
  desc "C SDK for Keyless Signature Infrastructure (c) Guardtime"
  homepage "https://github.com/guardtime/libksi"
  url "https://github.com/guardtime/libksi/archive/v3.16.2482.tar.gz"
  sha256 "a21c6ccdc432ec421df8977948c67bc4d62b50741b59f016c35a1aaf6767ee57"

  bottle do
    sha256 "31a0286d58f91f2d4a3a38a207f99ed9c020c479f8038359f0d8f8bfdf78a28c" => :high_sierra
    sha256 "4820f595f8cc05500d9d7ef55358d1479f75bf3b98767aa14795b54f645a2b22" => :sierra
    sha256 "d9bdc41ddb6d9945492feb765251d080a2b4205f4ad0f8ec538b231f66a3c002" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"

  def install
    system "autoreconf", "-if"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ksi/ksi.h>
      #include <assert.h>
      int main()
      {
        KSI_CTX *ksi = NULL;
        assert(KSI_CTX_new(&ksi) == KSI_OK);
        KSI_CTX_free(ksi);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}",
                   "-lksi", "-o", "test"
    system "./test"
  end
end
