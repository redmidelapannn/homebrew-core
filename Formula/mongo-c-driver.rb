class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.5.3/mongo-c-driver-1.5.3.tar.gz"
  sha256 "c617775b42ad3cd90f9f417bdf1fd141aef930d0b0f11ec1a1da1eeb7bc158e7"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cd35515a268a5e8c32548a28141477562df9794ba95b511535973be73de4f9bf" => :sierra
    sha256 "cc6bbe122396aa7512c6d05ec1e51e5ddcacf43482d7dad4c219514e0c344957" => :el_capitan
    sha256 "df51a9f99a329b3a4a8a6245c08aec10dd9874add4424b73aaa22c65c95146ae" => :yosemite
  end

  head do
    url "https://github.com/mongodb/mongo-c-driver.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-man-pages
      --with-libbson=bundled
      --enable-ssl=darwin
    ]

    system "./configure", *args
    system "make", "install"
    (pkgshare/"libbson").install "src/libbson/examples"
    (pkgshare/"mongoc").install "examples"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"libbson/examples/json-to-bson.c",
      "-I#{include}/libbson-1.0", "-L#{lib}", "-lbson-1.0"
    (testpath/"test.json").write('{"name": "test"}')
    assert_match "\u0000test\u0000", shell_output("./test test.json")

    system ENV.cc, "-o", "test", pkgshare/"mongoc/examples/mongoc-ping.c",
      "-I#{include}/libmongoc-1.0", "-I#{include}/libbson-1.0",
      "-L#{lib}", "-lmongoc-1.0", "-lbson-1.0"
    # The test below succeeds on OSX and linux (local installs) but fails or
    # succeeds depending on which continuous integration is used (jenkins, circle, travis)
    # assert_match '{ "ok" : 1 }', shell_output("./test mongodb://0.0.0.0 2>&1", 0)
  end
end
