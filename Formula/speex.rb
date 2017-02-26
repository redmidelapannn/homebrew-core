class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "http://speex.org"
  url "http://downloads.us.xiph.org/releases/speex/speex-1.2.0.tar.gz"
  sha256 "eaae8af0ac742dc7d542c9439ac72f1f385ce838392dc849cae4536af9210094"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b5afc5d28373835478b74ef45fb131b87327e883430ab8f711953b81a678286a" => :sierra
    sha256 "7f441dbb63b8a31563c6d616e3887a0c732fb8da80fa9e5ff2a9c71cbdac8762" => :el_capitan
    sha256 "252f8a1cb29916483f375d7cd6a5be934f994bc5acf4a78ba03c9278945d507a" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libogg" => :recommended

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
