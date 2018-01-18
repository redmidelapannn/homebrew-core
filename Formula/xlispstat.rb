class Xlispstat < Formula
  desc "Statistical data science environment based on Lisp"
  homepage "https://homepage.stat.uiowa.edu/~luke/xls/xlsinfo/"
  url "https://homepage.cs.uiowa.edu/~luke/xls/xlispstat/current/xlispstat-3-52-23.tar.gz"
  version "3.52.23"
  sha256 "9bf165eb3f92384373dab34f9a56ec8455ff9e2bf7dff6485e807767e6ce6cf4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "249e7d065e6339d2cdab475c6f366f254825541875c0473c1ba0cac679d2347f" => :high_sierra
    sha256 "eefc65bea8c28889cdc24ace652ff17726ecd634af6730847dedef3eb9c08812" => :sierra
    sha256 "4e371f53d39e7d3c1f062937244d2ff4709e8c6fa6768d9d4bd883c6600eb37c" => :el_capitan
  end

  depends_on :x11

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    ENV.deparallelize # Or make fails bytecompiling lisp code
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "> 50.5\n> ", pipe_output("#{bin}/xlispstat | tail -2", "(median (iseq 1 100))")
  end
end
