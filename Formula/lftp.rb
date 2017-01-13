class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.tech"
  url "https://lftp.yar.ru/ftp/lftp-4.7.5.tar.bz2"
  mirror "ftp://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/lftp-4.7.5.tar.bz2"
  sha256 "90f3cbc827534c3b3a391a2dd8b39cc981ac4991fa24b6f90e2008ccc0a5207d"

  bottle do
    sha256 "3e410a2717cb4e7768d32d5815c62bfe023ad9694fc478a385f6bce532621a18" => :sierra
    sha256 "9a8fb4472978ae8b35d3e9069ac0ac0faf30f9ef1488c0e2616ede4b96c8e6a9" => :el_capitan
  end

  depends_on "readline"
  depends_on "openssl"
  depends_on "libidn"

  # Fix a cast issue, patch was merged upstream: https://github.com/lavv17/lftp/pull/307
  # Remove when lftp-4.7.6 is released
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libidn=#{Formula["libidn"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lftp", "-c", "open ftp://mirrors.kernel.org; ls"
  end
end

__END__
--- a/src/Resolver.cc
+++ b/src/Resolver.cc
@@ -318,7 +318,7 @@ void Resolver::AddAddress(int family,const char *address,int len, unsigned int s
    case AF_INET6:
       if(sizeof(add.in6.sin6_addr) != len)
          return;
-      if(IN6_IS_ADDR_LINKLOCAL(address) && scope==0) {
+      if(IN6_IS_ADDR_LINKLOCAL((const struct in6_addr*)address) && scope==0) {
 	 error=_("Link-local IPv6 address should have a scope");
 	 return;
       }
