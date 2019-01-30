class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.io/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", :revision => 1981
  version "1.1.SVN"
  revision 2
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  bottle do
    rebuild 1
    sha256 "7f3348e7597e8575d01ad0908fd29e51458355424679ec95327100f48d048828" => :mojave
    sha256 "e54e27e6c3fd268b1a95ce9b551f631627c8c313f42c34d4b85c149e9e3db1c2" => :high_sierra
    sha256 "ede2d9fc65455da5370e382bf5a37ca7a8359ffe1b4d3092a71fd404f1a0ef6e" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install"
  end

  test do
    input = <<~EOS
      genmove white
      genmove black
    EOS
    output = pipe_output("#{bin}/fuego 2>&1", input, 0)
    assert_match "Forced opening move", output
    assert_match "maxgames", shell_output("#{bin}/fuego --help")
  end
end
