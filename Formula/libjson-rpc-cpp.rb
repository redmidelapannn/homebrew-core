class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.2.0.tar.gz"
  sha256 "485556bd27bd546c025d9f9a2f53e89b4460bf820fd5de847ede2539f7440091"
  revision 3
  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    cellar :any
    sha256 "0b51b8a23494223c9a228819ac26e648ff00dd44831ca1595bb73766f9fe409b" => :catalina
    sha256 "734f40b30b6535cde753bf136d08350753e447f5bdb9218341fe54543bc7d9bd" => :mojave
    sha256 "b366dd81048e738c3b0edd96652c99b0e08faa4153a7978a2feba5c7781a5339" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "hiredis"
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
