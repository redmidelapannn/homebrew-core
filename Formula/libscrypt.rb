class Libscrypt < Formula
  desc "Library for scrypt"
  homepage "https://lolware.net/libscrypt.html"
  url "https://github.com/technion/libscrypt/archive/v1.21.tar.gz"
  sha256 "68e377e79745c10d489b759b970e52d819dbb80dd8ca61f8c975185df3f457d3"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8e0af24844daa40345c73dfd606cdec79267eac233620f13d1a0c61b851bf4de" => :high_sierra
    sha256 "4f25335a72aa040611436d50311527d8574a8c20a62344dcceb6707f7d6e2020" => :sierra
    sha256 "06071c40aca4ed58c87aed75b3d1b5ba54747aa03b71e498849bf8ca93daf214" => :el_capitan
  end

  def install
    system "make", "install-osx", "PREFIX=#{prefix}", "LDFLAGS=", "CFLAGS_EXTRA="
    system "make", "check", "LDFLAGS=", "CFLAGS_EXTRA="
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libscrypt.h>
      int main(void) {
        char buf[SCRYPT_MCF_LEN];
        libscrypt_hash(buf, "Hello, Homebrew!", SCRYPT_N, SCRYPT_r, SCRYPT_p);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lscrypt", "-o", "test"
    system "./test"
  end
end
