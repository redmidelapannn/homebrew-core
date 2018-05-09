class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.4.0.tar.gz"
  sha256 "757a9b5b5dd3de801d7db8fab6035d97ea144b02a51c78bdab28a8e07bcf05d6"
  revision 1
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "f73f4a3671170e91f148cf4593a8eacb90b6a935cff15a7a0f52bbfd41829e4f" => :high_sierra
    sha256 "301c339ec809a0ce5031370578eb2fdd53fcd1d4cf98b20c539ce3c57bf92310" => :sierra
    sha256 "76ca341838ec5f6925c2fc904ae6aff156c2dc71d0b3d1c848cb9de2b3aab20c" => :el_capitan
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
