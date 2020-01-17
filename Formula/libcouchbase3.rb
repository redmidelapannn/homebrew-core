class Libcouchbase3 < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/3.0/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.0.0.tar.gz"
  sha256 "7688aaeb5e5833ef4bfe9ab79da58b7291b2f1c1b49b28e6567b598698a9c026"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "4ad8d984c483384f9772bd1794dcb906d66673168178bb52e31ec4b81426f230" => :catalina
    sha256 "0dde4c3dd8e29dfd6c8e32d056a66584ed79776a8aa0e2870d1e28dfcf66881e" => :mojave
    sha256 "d46017bb14b41583ec5b6b440de771e8764ebb730f4e7db7971226961cad5da0" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DLCB_NO_TESTS=1",
                            "-DLCB_BUILD_LIBEVENT=ON",
                            "-DLCB_BUILD_LIBEV=ON",
                            "-DLCB_BUILD_LIBUV=ON"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/cbc", "version"
  end
end
