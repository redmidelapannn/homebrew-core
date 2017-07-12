class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/current/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.7.6.tar.gz"
  sha256 "9b0c2a4de38963ec3314d19e50d63cc34a5990a4f6e0a81973c019d5ad83c411"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "e71720a31ca6708bda7eaf1ef39c3190772f7f3ecaf174b9c00e31e9dfdcae87" => :sierra
    sha256 "8626bd6cc5e75760367f79bdbfae1376f744659b448864cd7b67629609b6a74e" => :el_capitan
    sha256 "aed5e47398fedc7cc714c97cc6cabccea81bab3abd9d1c1c6dd6043994009999" => :yosemite
  end

  option "with-libev", "Build libev plugin"
  option "without-libevent", "Do not build libevent plugin"

  deprecated_option "with-libev-plugin" => "with-libev"
  deprecated_option "without-libevent-plugin" => "without-libevent"

  depends_on "libev" => :optional
  depends_on "libuv" => :optional
  depends_on "libevent" => :recommended
  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DLCB_NO_TESTS=1"

    ["libev", "libevent", "libuv"].each do |dep|
      args << "-DLCB_BUILD_#{dep.upcase}=" + (build.with?(dep) ? "ON" : "OFF")
    end
    if build.without?("libev") && build.without?("libuv") && build.without?("libevent")
      args << "-DLCB_NO_PLUGINS=1"
    end

    mkdir "LCB-BUILD" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/cbc", "version"
  end
end
