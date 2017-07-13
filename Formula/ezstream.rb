class Ezstream < Formula
  desc "Client for Icecast streaming servers"
  homepage "http://www.icecast.org/ezstream.php"
  url "https://downloads.xiph.org/releases/ezstream/ezstream-0.6.0.tar.gz"
  sha256 "f86eb8163b470c3acbc182b42406f08313f85187bd9017afb8b79b02f03635c9"

  bottle do
    cellar :any
    rebuild 2
    sha256 "137c1baa477cc9b27f78d5f0c0603054048cf39eacf5ab3845da569cc0d2ef43" => :sierra
    sha256 "01d90e0e2834ed2740bdbbb06fdb54d53b1a3752ef4004b22531051b7120345a" => :el_capitan
    sha256 "3aa9d796228b32ca2881b50f57702bec5a9603bf127474daeff7e118a0681a9c" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "libshout"
  depends_on "theora"
  depends_on "speex"
  depends_on "libogg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.m3u").write test_fixtures("test.mp3").to_s
    system bin/"ezstream", "-s", testpath/"test.m3u"
  end
end
