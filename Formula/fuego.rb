class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.io/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", :revision => 1981
  version "1.1.SVN"
  revision 2
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  bottle do
    rebuild 1
    sha256 "8ad260f4ccc16ae3d2ac8bc717df0def15888c72013677f5e6debd26d340c722" => :high_sierra
    sha256 "1cc84c7c3299d7782aacbba3f99550e2fab42ffb64e94300423bed08f09c4e1c" => :sierra
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
