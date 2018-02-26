class Apachetop < Formula
  desc "Top-like display of Apache log"
  homepage "https://web.archive.org/web/20170809160553/freecode.com/projects/apachetop"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/apachetop/apachetop_0.12.6.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/a/apachetop/apachetop_0.12.6.orig.tar.gz"
  sha256 "850062414517055eab2440b788b503d45ebe9b290d4b2e027a5f887ad70f3f29"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "38afbc04151d40dc81fd4921d51acdc83407d34bc6acd37b50b09453de3a9803" => :high_sierra
    sha256 "b4e9afcdef433a7c6e7c6eeae09ae4570d41e99a99eefe3a0ebf963bde11683c" => :sierra
    sha256 "fa7fc747849bab199d97af44709ff1f90e41b9afb60e5e556c7ba5d9c112be2b" => :el_capitan
  end

  # Freecode is officially static from this point forwards. Do not rely on it for up-to-date package information.
  # Upstream hasn't had activity in years, patch from MacPorts
  patch :p0, :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-logfile=/var/log/apache2/access_log"
    system "make", "install"
  end
end

__END__
--- src/resolver.h    2005-10-15 18:10:01.000000000 +0200
+++ src/resolver.h        2007-02-17 11:24:37.000000000 
0100
@@ -10,8 +10,8 @@
 class Resolver
 {
 	public:
-	Resolver::Resolver(void);
-	Resolver::~Resolver(void);
+	Resolver(void);
+	~Resolver(void);
 	int add_request(char *request, enum resolver_action act);
 
 
