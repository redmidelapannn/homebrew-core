class XmrigAmd < Formula
  desc "Monero AMD (OpenCL) miner"
  homepage "https://github.com/xmrig/xmrig-amd"
  url "https://github.com/xmrig/xmrig-amd/archive/v2.8.4.tar.gz"
  sha256 "3bc3669724c67e47a88e3878c1e345a1697aaa28e779afe9b972221bbece9a9d"

  bottle do
    cellar :any
    sha256 "3e7698b292cd666fdca5bfa0a65129aca09a5734090840586e47db2ec5f9533e" => :mojave
    sha256 "d352e0a76a345022278589cb1da21d63ab8c5c1e57b7dd4f63533c7da37bf0b5" => :high_sierra
    sha256 "94686fa387497d97ba39366214217e6d5bba40c8edc00023a1f5e38ee04b1049" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libmicrohttpd"
  depends_on "libuv"
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DUV_LIBRARY=#{Formula["libuv"].opt_lib}/libuv.dylib",
                            *std_cmake_args
      system "make"
      bin.install "xmrig-amd"
    end
    pkgshare.install "src/config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xmrig-amd -V", 2)
  end
end
