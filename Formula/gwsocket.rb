class Gwsocket < Formula
  desc "Simple, standalone, RFC6455 compliant WebSocket server"
  homepage "http://gwsocket.io/"
  url "http://tar.gwsocket.io/gwsocket-0.2.tar.gz"
  sha256 "dfe02cdc3c8bca02b498dd6e50161f6f672ad74bc05c4184939c118fd18eda98"

  bottle do
    cellar :any_skip_relocation
    sha256 "b882916c64189f1b27861eef62da40c6bf12790aff83e6db3da67974714bdc55" => :sierra
    sha256 "95d9bb93af40eb00a1e97d9ed288c1ff2d179c846e2c26872b217e59b1a6deb7" => :el_capitan
    sha256 "e7d5cac7a4ca0c446d3e0a8cb49b16bc3d08e06ce4ebdd92b9fee9dbe5b0e61d" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/gwsocket", "--version"
  end
end
