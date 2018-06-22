class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/current/sdk/c/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.9.1.tar.gz"
  sha256 "bc6e00313267ea9bc5b7c1dc672eba2194a9edb4d3ca0937a6d931e8c4f22643"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "234bbfa0b42388b58f28330ea322c294d3cf8a7aafe6d947afb956847a6273de" => :high_sierra
    sha256 "7b7c086c5d7124977545d93468054aa897016b407b1b784ad146d420d3dbf053" => :sierra
    sha256 "0f9c1b448b246f4998e1c232027c026ba9520498f93b2f117b4fae0bf1119dcd" => :el_capitan
  end

  option "with-libev", "Build libev plugin"

  deprecated_option "with-libev-plugin" => "with-libev"

  depends_on "libev" => :optional
  depends_on "libuv" => :optional
  depends_on "libevent"
  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    args = std_cmake_args << "-DLCB_NO_TESTS=1" << "-DLCB_BUILD_LIBEVENT=ON"

    ["libev", "libuv"].each do |dep|
      args << "-DLCB_BUILD_#{dep.upcase}=" + (build.with?(dep) ? "ON" : "OFF")
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
