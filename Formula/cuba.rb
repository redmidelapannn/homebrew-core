class Cuba < Formula
  desc "Library for multidimensional numerical integration"
  homepage "http://www.feynarts.de/cuba/"
  url "http://www.feynarts.de/cuba/Cuba-4.2.tar.gz"
  sha256 "da4197a194f7a79465dfb2c06c250caa8e76d731e9d6bdfd2dd6e81c8fc005e0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "689c4ce340728f4b37211ac2311a19a0b73ac9de1740d7405fec796db938efeb" => :catalina
    sha256 "7215bf1952c9fe3324093989a0162894d136fd788599ac03dc8ec0ad419fa733" => :mojave
    sha256 "2d3ec47800e3f714218ef5206258e0976592b6d633aa49ff80c0b19ef0aeceda" => :high_sierra
  end

  def install
    ENV.deparallelize # Makefile does not support parallel build
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "demo"
  end

  test do
    system ENV.cc, "-o", "demo", "-L#{lib}", "-lcuba",
                   "#{pkgshare}/demo/demo-c.c"
    system "./demo"
  end
end
