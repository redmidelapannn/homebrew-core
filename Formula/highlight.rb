class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.42.tar.bz2"
  sha256 "a582810384a0c1e870dcd2ca157ba4b5120f898ceb2fd370cfed4f86fc87311e"
  head "https://github.com/andre-simon/highlight.git"

  bottle do
    rebuild 1
    sha256 "4196727e137cc0438a5909d6e272a1fb034512f6ae8808e24aaa06387fb2793f" => :high_sierra
    sha256 "0409ff280c826ad926254a71a9667389b64cd6b01de284df057d0ee16bba369b" => :sierra
    sha256 "b95a6b1b90e9ffbaabab9c1bd679e4d7912e81d1e29416f4bdf333a64bab5fe0" => :el_capitan
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"extras/highlight_pipe.php"
  end
end
