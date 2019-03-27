class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.3/xapian-omega-1.4.3.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/x/xapian-omega/xapian-omega_1.4.3.orig.tar.xz"
  sha256 "2eea0344a0703ba379d845b86d08a9c2e9faf0deb21834d9ea6939b712c6216e"

  bottle do
    rebuild 1
    sha256 "f80058e480ff4ae9d9aa7270788166f181fea110176d59c4542749954addabdc" => :mojave
    sha256 "cce6eddf43979c41a96788c924f36e179c7572909516833a084bf32020faca91" => :high_sierra
    sha256 "586892ed1ae743fd4a6dee56f59a8e3de87f9206ccff9577edf17292b3f806ad" => :sierra
  end

  depends_on "libmagic"
  depends_on "pcre"
  depends_on "xapian"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/omindex", "--db", "./test", "--url", "/", "#{share}/doc/xapian-omega"
    assert_predicate testpath/"./test/flintlock", :exist?
  end
end
