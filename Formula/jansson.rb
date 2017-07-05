class Jansson < Formula
  desc "C library for encoding, decoding, and manipulating JSON"
  homepage "http://www.digip.org/jansson/"
  url "http://www.digip.org/jansson/releases/jansson-2.10.tar.gz"
  sha256 "78215ad1e277b42681404c1d66870097a50eb084be9d771b1d15576575cf6447"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4e543dde9d3eb73987d6fc1cecf490b083937ac61b035d0cb3c2c57fb5b61667" => :sierra
    sha256 "44df442b0316ec6fed8d83903a209fcf8d826fb6152384cf6b579bf0b0383d64" => :el_capitan
    sha256 "1fd067f24a9f4cf1952faa6f9b995c2b54f530a6294c782e8452889bfee3d608" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <jansson.h>
      #include <assert.h>

      int main()
      {
        json_t *json;
        json_error_t error;
        json = json_loads("\\"foo\\"", JSON_DECODE_ANY, &error);
        assert(json && json_is_string(json));
        json_decref(json);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ljansson", "-o", "test"
    system "./test"
  end
end
