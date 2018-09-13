class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "https://csl.name/jp2a/"
  url "https://downloads.sourceforge.net/project/jp2a/jp2a/1.0.6/jp2a-1.0.6.tar.gz"
  sha256 "0930ac8a9545c8a8a65dd30ff80b1ae0d3b603f2ef83b04226da0475c7ccce1c"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "066b881ae84ce86c6fc146d6e285a49fef8dd54746cd1fcdce4ca6c23ddbc7e3" => :mojave
    sha256 "4f7e887d3b7bfe64a9becee7476e218f03c7fb075a3c0d39c123601c41982ebb" => :high_sierra
    sha256 "7a9197d80c279dd1c5e534d0c17b41d5ce2dc8558ccb8ef750b741eb0435634d" => :sierra
    sha256 "383c2532b9be2b332dde0f29d88b738c3fef29946afc4cbd91e4c82b9eeba077" => :el_capitan
  end

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "test"
    system "make", "install"
  end

  test do
    system bin/"jp2a", test_fixtures("test.jpg")
  end
end
