class Ejdb < Formula
  desc "C library based on modified version of Tokyo Cabinet"
  homepage "https://ejdb.org/"
  url "https://github.com/Softmotions/ejdb/archive/v1.2.12.tar.gz"
  sha256 "858b58409a2875eb2b0c812ce501661f1c8c0378f7756d2467a72a1738c8a0bf"
  head "https://github.com/Softmotions/ejdb.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "bc0cc9f82850778f8359b0c5bc7ab76a8b82d7fe12988caacbc251ccf773c634" => :mojave
    sha256 "ee4033677bd26ed7ed10dd6abbe3ef334e338cf214cca9d8461c6353d50806f6" => :high_sierra
    sha256 "f2c57f0b02ca1acea5d5dcb835559f73d48e699d888d2d9fe87629598104d246" => :sierra
  end

  depends_on "cmake" => :build
  uses_from_macos "bzip2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ejdb/ejdb.h>

      static EJDB *jb;
      int main() {
          jb = ejdbnew();
          if (!ejdbopen(jb, "addressbook", JBOWRITER | JBOCREAT | JBOTRUNC)) {
              return 1;
          }
          EJCOLL *coll = ejdbcreatecoll(jb, "contacts", NULL);

          bson bsrec;
          bson_oid_t oid;

          bson_init(&bsrec);
          bson_append_string(&bsrec, "name", "Bruce");
          bson_append_string(&bsrec, "phone", "333-222-333");
          bson_append_int(&bsrec, "age", 58);
          bson_finish(&bsrec);

          ejdbsavebson(coll, &bsrec, &oid);
          bson_destroy(&bsrec);

          bson bq1;
          bson_init_as_query(&bq1);
          bson_append_start_object(&bq1, "name");
          bson_append_string(&bq1, "$begin", "Bru");
          bson_append_finish_object(&bq1);
          bson_finish(&bq1);

          EJQ *q1 = ejdbcreatequery(jb, &bq1, NULL, 0, NULL);

          uint32_t count;
          TCLIST *res = ejdbqryexecute(coll, q1, &count, 0, NULL);

          int i;
          for (i = 0; i < TCLISTNUM(res); ++i) {
              void *bsdata = TCLISTVALPTR(res, i);
              bson_print_raw(bsdata, 0);
          }
          tclistdel(res);

          ejdbquerydel(q1);
          bson_destroy(&bq1);

          ejdbclose(jb);
          ejdbdel(jb);
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lejdb", "-o", testpath/"test"
    system "./test"
  end
end
