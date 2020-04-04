class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.2.2.tar.gz"
  sha256 "d51e4e21ee1ee84ac8763de91bf485360cd76860b951ca998e891824c4f195ae"

  bottle do
    cellar :any
    sha256 "eca8dacfbd7ed470e55eb47b6ce20e1032f7b446cff2d86688bf3f388b9d993a" => :catalina
    sha256 "29e0c20cb82a0fd5247aef158daef5e13c96aea23aa02f6b0f70f0d68e303e5e" => :mojave
    sha256 "d2ba7af1e1780cae365154b05e8abcee5d5665f134b9611d26e7a599e425f1ef" => :high_sierra
  end

  depends_on :macos => :high_sierra # C++ 17 is required
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "postgresql"
  depends_on "sqlite"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    cd "test" do
      system ENV.cc, "select.c", "-L#{lib}", "-lzdb", "-I#{include}/zdb", "-o", "select"
      system "./select"
    end
  end
end
