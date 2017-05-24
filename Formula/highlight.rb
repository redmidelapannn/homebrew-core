class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.35.tar.bz2"
  sha256 "8a14b49f5e0c07daa9f40b4ce674baa00bb20061079473a5d386656f6d236d05"
  revision 1
  head "https://github.com/andre-simon/highlight.git"

  bottle do
    rebuild 1
    sha256 "d60842f055e7fd94c97b114915742db6b69eb02914879006cd6b780866b45a19" => :sierra
    sha256 "be032737f28422f8c5eee213660228f6897f58074a9a9d98d92f79baa6b56d3f" => :el_capitan
    sha256 "71ec392ba9cf25297e8560435874947df2f111c9d6ff32ba1d6fec6e8f2989b3" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"examples/highlight_pipe.php"
  end
end
