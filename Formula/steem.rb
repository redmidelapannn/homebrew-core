class Steem < Formula
  desc "Proof of Work blockchain with an unproven consensus algorithm."
  homepage "https://steemit.com/"
  url "https://github.com/steemit/steem.git",
      :tag => "v0.12.2",
      :revision => "b551cc7934f39b9f92151c6e414a397cb40647fd"

  bottle do
    sha256 "acc03083feba9901a69c49e1f3df6b96494b3db7a307627ba26fe73bd7d3cc57" => :el_capitan
    sha256 "20430c57b8c8cb4f4e5f02fb7f634f8cfe2848d802b1e42751912af6c550f9a8" => :yosemite
  end

  depends_on :macos => [:yosemite, :el_capitan, :sierra]

  depends_on "cmake" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :python3 => :build
  depends_on "doxygen" => :build
  depends_on "berkeley-db" => :optional
  depends_on "gperftools" => :optional
  depends_on "qt5" => :optional
  depends_on "icu4c"
  depends_on "boost"
  depends_on "openssl"
  depends_on "readline"

  def install
    cmake_args = %W[
      CMakeLists.txt
      -DLOW_MEMORY_NODE=ON
    ]

    cmake_args << "-DENABLE_CONTENT_PATCHING=OFF" if build.without? "qt5"

    system "cmake", *(cmake_args + std_cmake_args)
    system "make", "install"
  end

  test do
    system "#{bin}/steemd", "-h"
  end
end
