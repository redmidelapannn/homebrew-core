class Apachetop < Formula
  desc "Top-like display of Apache log"
  homepage "https://web.archive.org/web/20170809160553/freecode.com/projects/apachetop"
  url "https://deb.debian.org/debian/pool/main/a/apachetop/apachetop_0.12.6.orig.tar.gz"
  sha256 "850062414517055eab2440b788b503d45ebe9b290d4b2e027a5f887ad70f3f29"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "8a88289a39c620ee8f9c43edb9d66f4b8838d4c63ee5370cf15a9b9585369d87" => :mojave
    sha256 "109cf2acdec815254eba165c438492befefd3e82a413cc9735689927bf94318f" => :high_sierra
    sha256 "bd4e187fb49df1a5e8c3396863acdc95847b5ba6bcf33831c6b6da5c1e5dc238" => :sierra
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
