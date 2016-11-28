class Libmongoc < Formula
  desc "Cross Platform MongoDB Client Library for C"
  homepage "http://mongoc.org/"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.4.2/mongo-c-driver-1.4.2.tar.gz"
  sha256 "9154d8f6b3261f785a19d1f81506fb911c985f26dfdc9b19082e1bc7af479afb"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6d5abab3318435ddcd1217483235886ade8a55a64c4a5814bc924a8273f0e409" => :sierra
    sha256 "89ecad464ada5df14048c6b07403a3e7f2de828bcad82c66a92b8bfa911bf950" => :el_capitan
    sha256 "ec845f82822eba89fa33faab6ac7511fb2b04231e0b9e8e2116ab6d04206ee58" => :yosemite
  end

  conflicts_with "libbson",
                 :because => "libmongoc comes with a bundled libbson"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-man-pages",
                          "--enable-ssl=darwin"
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
    system ENV.cc, "test.c", "-L#{lib}", "-lbson-1.0", "-I#{include}/libbson-1.0", "-o", "test"
    system "./test"
  end
end
