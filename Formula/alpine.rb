class Alpine < Formula
  desc "News and email agent"
  homepage "http://repo.or.cz/alpine.git"
  url "https://ftp.osuosl.org/pub/blfs/conglomeration/alpine/alpine-2.21.tar.xz"
  mirror "https://fossies.org/linux/misc/alpine-2.21.tar.xz"
  sha256 "6030b6881b8168546756ab3a5e43628d8d564539b0476578e287775573a77438"

  bottle do
    rebuild 2
    sha256 "7c28d2a99f2b2b89110d61bf29492a3022d91ff113a0b102236dc9302c773e2b" => :high_sierra
    sha256 "c67b52e25b1363900b2169dfa2fab9c2f7b46f0c8ea5c840a34a4fb4578c1781" => :sierra
    sha256 "9146f55af0b9f63cf6f05e8057b850089107322c3abed5972099a1e679345907" => :el_capitan
  end

  depends_on "openssl"

  def install
    ENV.deparallelize

    args = %W[
      --disable-debug
      --with-ssl-dir=#{Formula["openssl"].opt_prefix}
      --with-ssl-certs-dir=#{etc}/openssl
      --prefix=#{prefix}
      --with-passfile=.pine-passfile
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-supported"
  end
end
