class Upscaledb < Formula
  desc "Database for embedded devices"
  homepage "https://upscaledb.com/"
  revision 9

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
    rebuild 1
    sha256 "793a389d0dbb598381ab243bd5b1c157b4a5367661328f7e0003ea21913bc3c1" => :mojave
    sha256 "936d59896d236f31a4eb42ec09431c41148ec95dac8470c24dd469d8c330b43d" => :high_sierra
    sha256 "7bf3206f202f3ad9d82aa7fa59aad990f482b3ecf25725b980a58cda4906a82e" => :sierra
    sha256 "161daaabcf16f9399adaaec6d521826ff1511ff8b05eb0a5a3333f42b95555c5" => :el_capitan
  end

  head do
    url "https://github.com/cruppstahl/upscaledb.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"
  depends_on "gnutls"
  depends_on "openssl"
  depends_on "protobuf"
  depends_on :java

  resource "libuv" do
    url "https://github.com/libuv/libuv/archive/v0.10.37.tar.gz"
    sha256 "4c12bed4936dc16a20117adfc5bc18889fa73be8b6b083993862628469a1e931"
  end

  fails_with :clang do
    build 503
    cause "error: member access into incomplete type 'const std::type_info"
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
