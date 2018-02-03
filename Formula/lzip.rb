class Lzip < Formula
  desc "LZMA-based compression program similar to gzip or bzip2"
  homepage "https://www.nongnu.org/lzip/"
  url "https://download.savannah.gnu.org/releases/lzip/lzip-1.19.tar.gz"
  sha256 "ffadc4f56be1bc0d3ae155ec4527bd003133bdc703a753b2cc683f610e646ba9"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "83b1965533ae5332e5ee704b6db2caaeb22bd02f6b62ed17617d1247bb4e04cc" => :high_sierra
    sha256 "e2e1219048ff52cbb985e5306da0c6ed6ac900cc5177542449089d8a55a4988d" => :sierra
    sha256 "db2da570cb04793591fb4af56e9739a58e185d94e36936af35656c696982ffd6" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lz
    system "#{bin}/lzip", path
    refute_predicate path, :exist?

    # decompress: data.txt.lz -> data.txt
    system "#{bin}/lzip", "-d", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end
