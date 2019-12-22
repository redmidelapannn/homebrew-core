class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v4.11.1/xrootd-4.11.1.tar.gz"
  sha256 "87fa867168e5accc36a37cfe66a3b64f2cf2a91e2975b85adbf5efda6c9d7029"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "39551efaaf2499b6f88dcdc76beabe11464819e74824c3bb84514bfdecddea7c" => :catalina
    sha256 "cf7791baedbbdd7f21aaa0a00743b740e4ef6da11ec0dc898541609f6b3d35c2" => :mojave
    sha256 "2cb08a959a155aa2c67386a597bb45f639eb9b73b6830751ab84a1d701298a1b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "readline"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_PYTHON=OFF"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
