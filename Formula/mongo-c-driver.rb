class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.10.1/mongo-c-driver-1.10.1.tar.gz"
  sha256 "630e83bfc97114a9936f0b6871bfd593b538839caf1d3f93c8038148d1b9a4d6"
  head "https://github.com/mongodb/mongo-c-driver.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "05d2c4ac7e22e4f10799cf6cbdbb0789cc5be8615f3a265a820a058d256d406c" => :high_sierra
    sha256 "96c636682aad13222cbead5ae57f0ce1b85223136ce13e40f13839603cbf0550" => :sierra
    sha256 "bd51224c0d1d84bdab1f8eae710aee22b939d315692d12e2d0712a1a37408a21" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    (pkgshare/"libbson").install "src/libbson/examples"
    (pkgshare/"libmongoc").install "src/libmongoc/examples"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"libbson/examples/json-to-bson.c",
      "-I#{include}/libbson-1.0", "-L#{lib}", "-lbson-1.0"
    (testpath/"test.json").write('{"name": "test"}')
    assert_match "\u0000test\u0000", shell_output("./test test.json")

    system ENV.cc, "-o", "test", pkgshare/"libmongoc/examples/mongoc-ping.c",
      "-I#{include}/libmongoc-1.0", "-I#{include}/libbson-1.0",
      "-L#{lib}", "-lmongoc-1.0", "-lbson-1.0"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 3)
  end
end
