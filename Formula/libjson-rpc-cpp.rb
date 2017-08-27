class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.0.0.tar.gz"
  sha256 "888c10f4be145dfe99e007d5298c90764fb73b58effb2c6a3fc522a5b60a18c6"

  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    cellar :any
    sha256 "f3a6a4c2535fcc7a05083e062c384aa8fd1fe2f80c20173cbc16ebccc1944af2" => :sierra
    sha256 "dcc8f16901b5687d5e4c00f3d7a84336ffd0de8b751e8628ef8b772adae2b2ea" => :el_capitan
    sha256 "6ea4b7a11033916fdb032d5f812c32bcfe2ec5049699fbde329736fa8f260162" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"
  depends_on "hiredis"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end
