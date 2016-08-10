class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  revision 1

  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  stable do
    url "https://github.com/cinemast/libjson-rpc-cpp/archive/v0.6.0.tar.gz"
    sha256 "98baf15e51514339be54c01296f0a51820d2d4f17f8c9d586f1747be1df3290b"

    # upstream commit: "fix parallel build, wait for catch to be downloaded"
    patch do
      url "https://github.com/cinemast/libjson-rpc-cpp/commit/e9cb9dde.patch"
      sha256 "6ea275607540fbae7a1423d9e74b983f81bc85e114822d7dc36c6d56aa69aeb8"
    end
  end

  bottle do
    cellar :any
    revision 1
    sha256 "e81312ccf59e2f9d8b994e4b4c99cc0b1b0aa2aff3cc4b2958e9223310e13cca" => :el_capitan
    sha256 "76c986dcd051ee4a1c7c305e9827b66bdb4dcb95a5f252a63fa0d829776ba79f" => :yosemite
    sha256 "5cf91ba1c26156767b27628312cd57e5cb3b0f8551837516469109590749ff60" => :mavericks
  end

  devel do
    url "https://github.com/cinemast/libjson-rpc-cpp/archive/v0.7.0.tar.gz"
    sha256 "669c2259909f11a8c196923a910f9a16a8225ecc14e6c30e2bcb712bab9097eb"
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end
