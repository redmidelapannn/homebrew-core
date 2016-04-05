class Alpine < Formula
  desc "News and email agent"
  homepage "http://patches.freeiz.com/alpine/"
  url "http://patches.freeiz.com/alpine/release/src/alpine-2.20.tar.xz"
  sha256 "ed639b6e5bb97e6b0645c85262ca6a784316195d461ce8d8411999bf80449227"

  bottle do
    revision 1
    sha256 "14bec6b9f8540e0395d98fb87a476d96e67fe5367ff9265b1febd89d1e308ced" => :el_capitan
    sha256 "d6f26b91f2f243161b5526f912c224f0d909f13be28e4f8814e5ae9a4a755977" => :yosemite
    sha256 "75434a0d012260a87ffeec6e6d500d453dba93eede90e7fbcd7b68eeb7f8cc4d" => :mavericks
  end

  depends_on "openssl"

  def install
    ENV.j1
    system "./configure", "--disable-debug",
                          "--with-local-password-cache",
                          "--with-ssl-dir=#{Formula["openssl"].opt_prefix}",
                          "--with-ssl-certs-dir=#{etc}/openssl",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-supported"
  end
end
