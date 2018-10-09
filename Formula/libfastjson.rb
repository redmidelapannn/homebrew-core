class Libfastjson < Formula
  desc "Fast JSON library for C"
  homepage "https://github.com/rsyslog/libfastjson/"
  url "http://download.rsyslog.com/libfastjson/libfastjson-0.99.8.tar.gz"
  sha256 "3544c757668b4a257825b3cbc26f800f59ef3c1ff2a260f40f96b48ab1d59e07"

  bottle do
    cellar :any
    sha256 "92f3c03a3771ae7929f5ad8ab7f96fdee93609906a305749e83541d4506d7fea" => :mojave
    sha256 "225926848c704353d3f5945a2284eac805038d4e2835cefc144b912738914289" => :high_sierra
    sha256 "ef7337d400ef712abc33ec002c179d5e4640a8fe1c2bb0a542ed2bf24e43f8ce" => :sierra
  end

  depends_on "pkg-config" => :build

  def install
    ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "-prefix=#{prefix}",
                          "--libdir=#{lib}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "stdio.h"
      #include <json.h>
      int main() {
      printf("%s\\n", fjson_version());
      return 0;
      }
    EOS

    cflags = `pkg-config --cflags libfastjson`.split(" ")
    system ENV.cc, "test.c", *cflags, "-L#{lib}", "-lfastjson", "-o", "test"
    system "./test"
  end
end
