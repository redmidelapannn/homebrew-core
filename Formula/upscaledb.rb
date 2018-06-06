class Upscaledb < Formula
  desc "Database for embedded devices"
  homepage "https://upscaledb.com/"
  revision 8

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
    sha256 "37bd86cf5b82b4d79c6be0a9e1f37c4f8d8f644f7020507ef13ac4a498223a19" => :high_sierra
    sha256 "87dcb976655e1a7b310fb9a614cb69014fa99dfa8e97bdb677f829f4b7a154d2" => :sierra
    sha256 "63c243c7f93e2b7b71fbaa16327e7b9f3b835aada90b92ed5440f471ef9ffc33" => :el_capitan
  end

  head do
    url "https://github.com/cruppstahl/upscaledb.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "without-java", "Do not build the Java wrapper"
  option "without-protobuf", "Disable access to remote databases"

  deprecated_option "without-remote" => "without-protobuf"

  depends_on "boost"
  depends_on "gnutls"
  depends_on "openssl"
  depends_on :java => :recommended
  depends_on "protobuf" => :recommended

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

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.with? "java"
      args << "JDK=#{ENV["JAVA_HOME"]}"
    else
      args << "--disable-java"
    end

    if build.with? "protobuf"
      resource("libuv").stage do
        system "make", "libuv.dylib", "SO_LDFLAGS=-Wl,-install_name,#{libexec}/libuv/lib/libuv.dylib"
        (libexec/"libuv/lib").install "libuv.dylib"
        (libexec/"libuv").install "include"
      end

      ENV.prepend "LDFLAGS", "-L#{libexec}/libuv/lib"
      ENV.prepend "CFLAGS", "-I#{libexec}/libuv/include"
      ENV.prepend "CPPFLAGS", "-I#{libexec}/libuv/include"
    else
      args << "--disable-remote"
    end

    system "./configure", *args
    system "make", "install"

    pkgshare.install "samples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lupscaledb",
           pkgshare/"samples/db1.c", "-o", "test"
    system "./test"
  end
end
