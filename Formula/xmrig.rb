class Xmrig < Formula
  desc ""
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig.git", :tag => "v2.2.1", :revision => "92d787c817dfa92ca38e36f634195f31ff7d40c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ed568eb7bba26596e5477e39c7f457773acd31e914021e07057d22a03a8d4fd" => :sierra
    sha256 "5d8a7d51e12e0221c74a809b84e02fd12a763a6363cfb0395d71631a7cda1b44" => :el_capitan
    sha256 "593eaef3d1112fbf8592d3c0d69b92e31d6615b3bbc024af000ffd28bc60f913" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "libuv"

  def install
    Dir.mkdir("build")
    Dir.chdir("build")
    system "cmake", "..", "-DCMAKE_BUILD_TYPE=Release", "-DUV_LIBRARY=/usr/local/opt/libuv/lib/libuv.a", *std_cmake_args
    system "make"
    bin.install "xmrig"
  end

  test do
    system "#{bin}/xmrig", "-V"
  end
end
