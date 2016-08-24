class BerkeleyDb < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/technology/products/berkeley-db/index.html"
  url "http://download.oracle.com/berkeley-db/db-6.1.26.tar.gz"
  sha256 "dd1417af5443f326ee3998e40986c3c60e2a7cfb5bfa25177ef7cadb2afb13a6"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0937e413698cd54c065b2a31dd7593c33e397c4a1eea49594bfa14ffa0ccfec1" => :el_capitan
    sha256 "fe03c33857293dafb615589cb7e7e66ddebbdc71de83165ab85401178fd01ee9" => :yosemite
    sha256 "1624a831b6a2e595038b3bbff2fdbbe4fff9af77e550f2e6ec8394f3b7517f08" => :mavericks
  end

  option "with-java", "Compile with Java support."
  option "with-sql", "Compile with SQL support."

  deprecated_option "enable-sql" => "with-sql"

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize
    # --enable-compat185 is necessary because our build shadows
    # the system berkeley db 1.x
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-cxx
      --enable-compat185
    ]
    args << "--enable-java" if build.with? "java"
    args << "--enable-sql" if build.with? "sql"

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    cd "build_unix" do
      system "../dist/configure", *args
      system "make", "install"

      # use the standard docs location
      doc.parent.mkpath
      mv prefix/"docs", doc
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <assert.h>
      #include <string.h>
      #include <db_cxx.h>
      int main() {
        Db db(NULL, 0);
        assert(db.open(NULL, "test.db", NULL, DB_BTREE, DB_CREATE, 0) == 0);

        const char *project = "Homebrew";
        const char *stored_description = "The missing package manager for OS X";
        Dbt key(const_cast<char *>(project), strlen(project) + 1);
        Dbt stored_data(const_cast<char *>(stored_description), strlen(stored_description) + 1);
        assert(db.put(NULL, &key, &stored_data, DB_NOOVERWRITE) == 0);

        Dbt returned_data;
        assert(db.get(NULL, &key, &returned_data, 0) == 0);
        assert(strcmp(stored_description, (const char *)(returned_data.get_data())) == 0);

        assert(db.close(0) == 0);
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -ldb_cxx
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
    assert (testpath/"test.db").exist?
  end
end
