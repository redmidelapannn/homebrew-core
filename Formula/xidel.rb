class Xidel < Formula
  desc "XPath/XQuery 3.0, JSONiq interpreter to extract data from HTML/XML/JSON"
  homepage "http://www.videlibri.de/xidel.html"
  url "https://github.com/benibela/xidel/releases/download/Xidel_0.9.8/xidel-0.9.8.src.tar.gz"
  sha256 "72b5b1a2fc44a0a61831e268c45bc6a6c28e3533b5445151bfbdeaf1562af39c"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "328f44e541abeee1eaedb19e263debcb9d2a3d1a52b305cb020619a21a863ea7" => :catalina
    sha256 "5ffa342416c5c320d2a67daaa575ec8476de4e21ef6f471570532b67880e8021" => :mojave
    sha256 "ac9fb851d8cae47a507073e4284e28a10836ad45e605c484e51e780193ea57f3" => :high_sierra
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
