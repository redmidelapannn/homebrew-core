class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/v3.4.2.tar.gz"
  sha256 "69897a5167f34e8a84c7069f1b283aba88cdfa8ec183165c4a5da2c816cfaadb"
  head "https://github.com/sqlcipher/sqlcipher.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9615ef3d9fe07756d982d026ab99d61bcdaa72784e4043a3e4651ac6226a9235" => :mojave
    sha256 "4c48a0b288c8edd5ff25e374f000d4baa848e32cc201b7f5d2bb39c6a394b3bb" => :high_sierra
    sha256 "44e0642d437fed6a8d6babfa22fca5e356602323cc850a3dcd5bac741629539d" => :sierra
  end

  option "with-fts", "Build with full-text search enabled"
  option "with-static-linking", "Build SQLCipher with OpenSSL statically linked instead of dynamically linked"

  depends_on "openssl"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-tempstore=yes
      --with-crypto-lib=openssl
      --enable-load-extension
      --disable-tcl
    ]

    # Static vs. dynamic linking of libcrypto is documented here:
    # https://www.zetetic.net/sqlcipher/introduction/
    if build.with?("static-linking")
      args << %Q(LDFLAGS=#{Formula["openssl"].opt_prefix}/lib/libcrypto.a)
    else
      args << %Q(LDFLAGS=-L#{Formula["openssl"].opt_prefix}/lib -lcrypto)
    end

    if build.with?("fts")
      args << "CFLAGS=-DSQLITE_HAS_CODEC -DSQLITE_ENABLE_JSON1 -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS -DSQLITE_ENABLE_FTS5"
    else
      args << "CFLAGS=-DSQLITE_HAS_CODEC -DSQLITE_ENABLE_JSON1"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    path = testpath/"school.sql"
    path.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', json_extract('{"age": 13}', '$.age'));
      select name from students order by age asc;
    EOS

    names = shell_output("#{bin}/sqlcipher < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
