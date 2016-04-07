class Alpine < Formula
  desc "News and email agent"
  homepage "http://patches.freeiz.com/alpine/"
  url "http://patches.freeiz.com/alpine/release/src/alpine-2.20.tar.xz"
  sha256 "ed639b6e5bb97e6b0645c85262ca6a784316195d461ce8d8411999bf80449227"

  bottle do
    revision 1
    sha256 "8b90ada2ebf7c4a52a3c43913e7930b378a0a4dd4bd49910d122b9e3c67774c8" => :el_capitan
    sha256 "403996c4559e7fe2ac799b0e5efbf6930cc33aa562cf2150182be904e339acee" => :yosemite
    sha256 "0196876a703fbdf05c1a1123b3d12ae9f6c9c6b69c1641a941fbbc99ece076e9" => :mavericks
  end

  option "with-maildir", "Compile with support for Maildir format mailboxes"

  depends_on "openssl"

  patch do
    url "http://patches.freeiz.com/alpine/patches/alpine-2.20/maildir.patch.gz"
    sha256 "1ef0932b80d7f790ce6577a521a7b613b5ce277bb13cbaf0116bb5de1499caaa"
  end if build.with? "maildir"

  def install
    ENV.j1
    system "./configure", "--disable-debug",
                          "--with-ssl-dir=#{Formula["openssl"].opt_prefix}",
                          "--with-ssl-certs-dir=#{etc}/openssl",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-supported"
  end
end
