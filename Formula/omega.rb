class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "http://oligarchy.co.uk/xapian/1.2.18/xapian-omega-1.2.18.tar.xz"
  sha256 "528feb8021a52ab06c7833cb9ebacefdb782f036e99e7ed5342046c3a82380c2"

  bottle do
    revision 2
    sha256 "4022655407c91189e73533232ed351360e63f7a2fcaa8aeaf03f860f6dd23a1d" => :el_capitan
    sha256 "0dbffd02c5ea47af14496451d9845d7244f7115c6ac976bdb088814fb3d10d17" => :yosemite
    sha256 "32d640be124c9a007fa30765b85576e227e5b2e0cc631bcf3bc095f53fe50bbb" => :mavericks
  end

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
    assert File.exist?("./test/flintlock")
  end
end
