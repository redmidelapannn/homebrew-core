class Tcpurify < Formula
  desc "Packet sniffer/capture program"
  homepage "https://web.archive.org/web/20140203210616/irg.cs.ohiou.edu/~eblanton/tcpurify/"
  url "https://web.archive.org/web/20140203210616/irg.cs.ohiou.edu/~eblanton/tcpurify/tcpurify-0.11.2.tar.gz"
  sha256 "9822f88125e912c568de23b04cee7c84452eefa27a80dcaeaeb001f87cb60e99"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a7f81e418ba162f953b6e31238751f78377e77d5460eb5a6bba4b2bcaf48da3b" => :sierra
    sha256 "67494ea742f1bb5f6834299d0f7d092bf6802647e0c43dcba1479d7d8477d426" => :el_capitan
    sha256 "d7dc47275fff143443a1b096b953f383b66115183d33953a310364b1bfdb04db" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tcpurify", "-v"
  end
end
