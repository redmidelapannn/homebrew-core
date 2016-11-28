class Libmongoc < Formula
  desc "Cross Platform MongoDB Client Library for C"
  homepage "http://mongoc.org/"
  # Note: libbson and libmongoc must be kept in sync. Do not update one without updating the other.
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.5.0/mongo-c-driver-1.5.0.tar.gz"
  sha256 "b9b7514052fe7ec40786d8fc22247890c97d2b322aa38c851bba986654164bd6"
  revision 1

  bottle do
    cellar :any
    sha256 "b87726f6c19b6bfd57e0508326c7a82c73e242d29b1547b992d34eeb346dc25d" => :sierra
    sha256 "35c55a4f5c1d1c834aa8e2cc2fe9d831c1510d572c00be6cce00d8512e1dc4a0" => :el_capitan
    sha256 "5119b2b3c9fdd1517124a3611cd658f231de639cad493b9ae4725d647fe3a9f7" => :yosemite
  end

  depends_on "libbson"
  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-man-pages",
                          "--enable-ssl=darwin",
                          "--with-libbson=system"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <bson.h>
      int main() {
        bson_t *b;
        if (!bson_init_from_json(b, "{}", -1, NULL))
          return 1;
        bson_destroy(b);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lbson-1.0", "-I#{Formula["libbson"].opt_include}/libbson-1.0", "-o", "test"
    system "./test"
  end
end
