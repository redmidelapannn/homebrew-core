class Alpine < Formula
  desc "News and email agent"
  homepage "https://repo.or.cz/alpine.git"
  url "https://ftp.osuosl.org/pub/blfs/conglomeration/alpine/alpine-2.21.tar.xz"
  mirror "https://fossies.org/linux/misc/alpine-2.21.tar.xz"
  sha256 "6030b6881b8168546756ab3a5e43628d8d564539b0476578e287775573a77438"
  revision 2

  bottle do
    sha256 "7a96a0f48ce93cb548a4d6a260c1e28ca3dd0037e5e6a72c2fe9d072cb9083b2" => :catalina
    sha256 "2e990965dc7d59bbd75e6233daa89d89f9fd070db3709c9d24b9de4ec9a788bd" => :mojave
    sha256 "236e45f9c23be467c9289703a31f0969e7f24371436662514a8dce09e8826244" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    ENV.deparallelize

    args = %W[
      --disable-debug
      --with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}
      --with-ssl-certs-dir=#{etc}/openssl@1.1
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
    system "./install-sh", "-t", bin.to_s, "imap/mailutil/mailutil"
  end

  test do
    system "#{bin}/alpine", "-supported"
  end
end
