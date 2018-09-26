class Upscaledb < Formula
  desc "Database for embedded devices"
  homepage "https://upscaledb.com/"
  revision 10

  stable do
    url "http://files.upscaledb.com/dl/upscaledb-2.2.0.tar.gz"
    mirror "https://dl.bintray.com/homebrew/mirror/upscaledb-2.2.0.tar.gz"
    sha256 "7d0d1ace47847a0f95a9138637fcaaf78b897ef682053e405e2c0865ecfd253e"

    # Remove for > 2.2.2
    # Upstream commit from 12 Feb 2018 "Fix compilation with Boost 1.66 (#110)"
    patch do
      url "https://github.com/cruppstahl/upscaledb/commit/01156f9a8.patch?full_index=1"
      sha256 "e65b9f2b624b7cdad00c3c1444721cadd615688556d8f0bb389d15f5f5f4f430"
    end
  end

  bottle do
    cellar :any
    sha256 "2c5d99c25a73248df456cfc2edeb0ea15704d9a67d814b9a19525ed4885de379" => :mojave
    sha256 "e5182521ca26ba69cfc490807712e38edfca13a00070977cca77a7ccebf32a4e" => :high_sierra
    sha256 "03a1936306e8558e2ef6842fc6bf75814ab19fcff02e549ca44b6b890f59d49c" => :sierra
  end

  head do
    url "https://github.com/cruppstahl/upscaledb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"
  depends_on "gnutls"
  depends_on :java
  depends_on "openssl"
  depends_on "protobuf"

  fails_with :clang do
    build 503
    cause "error: member access into incomplete type 'const std::type_info"
  end

  resource "libuv" do
    url "https://github.com/libuv/libuv/archive/v0.10.37.tar.gz"
    sha256 "4c12bed4936dc16a20117adfc5bc18889fa73be8b6b083993862628469a1e931"
  end

  def install
    # Fix collision with isset() in <sys/params.h>
    # See https://github.com/Homebrew/homebrew-core/pull/4145
    inreplace "./src/5upscaledb/upscaledb.cc",
      "#  include \"2protobuf/protocol.h\"",
      "#  include \"2protobuf/protocol.h\"\n#define isset(f, b)       (((f) & (b)) == (b))"

    system "./bootstrap.sh" if build.head?

    resource("libuv").stage do
      system "make", "libuv.dylib", "SO_LDFLAGS=-Wl,-install_name,#{libexec}/libuv/lib/libuv.dylib"
      (libexec/"libuv/lib").install "libuv.dylib"
      (libexec/"libuv").install "include"
    end

    ENV.prepend "LDFLAGS", "-L#{libexec}/libuv/lib"
    ENV.prepend "CFLAGS", "-I#{libexec}/libuv/include"
    ENV.prepend "CPPFLAGS", "-I#{libexec}/libuv/include"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "JDK=#{ENV["JAVA_HOME"]}"
    system "make", "install"

    pkgshare.install "samples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lupscaledb",
           pkgshare/"samples/db1.c", "-o", "test"
    system "./test"
  end
end
