class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/2.10/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.10.3.tar.gz"
  sha256 "1cc6c6a41dd1c92e26830e227b42c705bf6c4005342fb609d60fe2b63a5c5aa6"
  revision 1
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "a2f620db3141be382ac76725f9c1feb1752275fe9d967b64a668186079a54953" => :mojave
    sha256 "de92b2c16dd8ed1ee609a41132d124d050ac7cf4d578f9013eb214005f3336b8" => :high_sierra
    sha256 "bfdd609e4b24acf5cb83f2b531fe3e4fdc4455225b3fc3d0d5ab99de3eaf4829" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl"

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
