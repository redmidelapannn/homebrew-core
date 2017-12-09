class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.3.3.tar.gz"
  sha256 "6eed82895da1359538471cbcc82576c4a21a4c6854e1f125fc55215f7c51da52"
  revision 3
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "dc39a8e531f9fcbb9a39875e5197637696f002ab09a2924066c3f66684c7c55c" => :high_sierra
    sha256 "ef140f74f9de6cd8cc06b1d1d15a2770619dfc576c97968c3ef44056c467ccc8" => :sierra
    sha256 "772c7033cd292783eed8cc53680f0ee9ec58984b6b2d180a9cf05f432cee8ad6" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "json-c"
  depends_on "libwebsockets"

  def install
    cmake_args = std_cmake_args + ["-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"]
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttyd --version")
  end
end
