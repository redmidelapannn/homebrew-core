class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.5.2.tar.gz"
  sha256 "b5b62ec2ce08add0173e6d1dfdd879e55f02f9490043e89f389981a62e87d376"
  revision 3
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "24d493ffeb659bccd5383e101acd29963d1fdf04ea3eab792790aeec6079b685" => :mojave
    sha256 "b65c0e49d91d88c5fb29b5bc912088b2d7269f57c8114e84c017b3c1c29c57b5" => :high_sierra
    sha256 "fa5f8aaf54b5e4eec35908d384a5b816a4bd0892359569bd711fccea2f389026" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@1.1"

  def install
    system "cmake", ".",
                    *std_cmake_args,
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttyd --version")
  end
end
