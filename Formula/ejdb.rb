class Ejdb < Formula
  desc "C library based on modified version of Tokyo Cabinet"
  homepage "http://ejdb.org"
  url "https://github.com/Softmotions/ejdb/archive/v1.2.12.tar.gz"
  sha256 "858b58409a2875eb2b0c812ce501661f1c8c0378f7756d2467a72a1738c8a0bf"

  head "https://github.com/Softmotions/ejdb.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3aa6efe9e17eddaa70d8b2113c2c73421113b10047af99abb3e788e3c11ca257" => :sierra
    sha256 "ad0eeac37664f1358efe863b25da5b93d8c9e7b4bbf098efd9f38d9f81691b26" => :el_capitan
    sha256 "2696a7be76c626d416d07509c4f6590880f8bfeea1a8ece939a8d5b74cf15a39" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
