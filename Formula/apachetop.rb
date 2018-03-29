class Apachetop < Formula
  desc "Top-like display of Apache log"
  homepage "https://web.archive.org/web/20170809160553/freecode.com/projects/apachetop"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/apachetop/apachetop_0.12.6.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/a/apachetop/apachetop_0.12.6.orig.tar.gz"
  sha256 "850062414517055eab2440b788b503d45ebe9b290d4b2e027a5f887ad70f3f29"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "38e8676001e64f90c7cd0182ee5b7d11ebdcee544f9b2d1ec062f3f7dc3c0a37" => :high_sierra
    sha256 "256a278c0c83382b8ce137a6331caed59ddddd1cbebafbe35616fa9b3a4f9c1a" => :sierra
    sha256 "c824800df927ba0cab747e49c86139dcb5109b0b2ef8b355576c81ba17fd6e7a" => :el_capitan
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

  test do
    output = shell_output("#{bin}/apachetop -h 2>&1", 1)
    assert_match "ApacheTop v#{version}", output
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
 
 
