class Rdfind < Formula
  desc "Find duplicate files based on content (NOT file names)"
  homepage "https://rdfind.pauldreik.se/"
  url "https://rdfind.pauldreik.se/rdfind-1.4.1.tar.gz"
  sha256 "30c613ec26eba48b188d2520cfbe64244f3b1a541e60909ce9ed2efb381f5e8c"
  revision 1

  bottle do
    cellar :any
    sha256 "b370dd3946bf3ffff44de76d3efdabe6ca880c57740bd779a7c85ebc9ff7d0eb" => :catalina
    sha256 "eca0cece9873dea2e4b6e22e0fde87cb294d9cfb11aa5508864f83182500fb0e" => :mojave
    sha256 "fe07cf51ad1e3a3f0c173e859df4ecad8e062a9bd5b1028d8e6f84bb0fc5d9b4" => :high_sierra
  end

  depends_on "nettle"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir "folder"
    (testpath/"folder/file1").write("foo")
    (testpath/"folder/file2").write("bar")
    (testpath/"folder/file3").write("foo")
    system "#{bin}/rdfind", "-deleteduplicates", "true", "folder"
    assert_predicate testpath/"folder/file1", :exist?
    assert_predicate testpath/"folder/file2", :exist?
    refute_predicate testpath/"folder/file3", :exist?
  end
end
