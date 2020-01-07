class Xidel < Formula
  desc "XPath/XQuery 3.0, JSONiq interpreter to extract data from HTML/XML/JSON"
  homepage "http://www.videlibri.de/xidel.html"
  url "https://github.com/benibela/xidel/releases/download/Xidel_0.9.8/xidel-0.9.8.src.tar.gz"
  sha256 "72b5b1a2fc44a0a61831e268c45bc6a6c28e3533b5445151bfbdeaf1562af39c"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "190a27f9a52428dddf17bbe12f264fc1832a16c43a32fcabe47558175e1e7c1d" => :catalina
    sha256 "1b077dbae36df49e5eea0519bcb7fc4ff9cc34d3f15244018ade5a3d2ed13781" => :mojave
    sha256 "b81c7c82a3aa73b9ca8f2e6e849e9895673cafeec0fc4a15c9bd3dec893cd044" => :high_sierra
  end

  depends_on "fpc"
  depends_on "openssl@1.1"

  def install
    cd "programs/internet/xidel" do
      system "./build.sh"
      bin.install "xidel"
      man1.install "meta/xidel.1"
    end
  end

  test do
    assert_equal "123\n", shell_output("#{bin}/xidel -e 123")
  end
end
