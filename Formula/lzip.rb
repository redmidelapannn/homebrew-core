class Lzip < Formula
  desc "LZMA-based compression program similar to gzip or bzip2"
  homepage "http://www.nongnu.org/lzip/lzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/lzip-1.19.tar.gz"
  sha256 "ffadc4f56be1bc0d3ae155ec4527bd003133bdc703a753b2cc683f610e646ba9"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "b9396eb6d6157f85f8feb07c8953a5055b7605bdc9a0bc83b10b723a061928a2" => :sierra
    sha256 "b97d90de3cb3bc0ddeb29de1f0d41dff49f7297f2193fab2760f359c1acc027c" => :el_capitan
    sha256 "e87c8c67cf8088336db5bb9176b3b0d7176040a2b322c9253d43bdd020a5a700" => :yosemite
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
    assert !path.exist?

    # decompress: data.txt.lz -> data.txt
    system "#{bin}/lzip", "-d", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end
