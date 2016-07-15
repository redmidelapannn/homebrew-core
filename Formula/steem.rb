class Steem < Formula
  desc "Proof of Work blockchain with an unproven consensus algorithm."
  homepage "https://steemit.com/"
  url "https://github.com/steemit/steem.git",
      :tag => "v0.9.0rc2",
      :revision => "54337e4eae639aaf1150611923ea1e04693905e6"

  depends_on :macos => [:yosemite, :el_capitan, :sierra]

  depends_on "cmake" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :python3 => :build
  depends_on "doxygen" => :build
  depends_on "berkeley-db" => :optional
  depends_on "gperftools" => :optional
  depends_on "icu4c"
  depends_on "boost"
  depends_on "openssl"
  depends_on "readline"

  def install
    system "cmake", "-DENABLE_CONTENT_PATCHING=OFF", "-DLOW_MEMORY_NODE=ON", "CMakeLists.txt", *std_cmake_args
    system "make"
    bin.install "programs/steemd/steemd"
    bin.install "programs/cli_wallet/cli_wallet"
  end

  test do
    system "#{bin}/steemd", "-h"
  end
end
