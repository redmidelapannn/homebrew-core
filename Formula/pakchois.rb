class Pakchois < Formula
  desc "PKCS #11 wrapper library"
  homepage "https://web.archive.org/web/www.manyfish.co.uk/pakchois/"
  url "https://web.archive.org/web/20161220165909/www.manyfish.co.uk/pakchois/pakchois-0.4.tar.gz"
  sha256 "d73dc5f235fe98e4d1e8c904f40df1cf8af93204769b97dbb7ef7a4b5b958b9a"

  bottle do
    rebuild 1
    sha256 "be0e2851e0008ca2eda5101230c64c73976622354eaaeba16364f3586e289d24" => :high_sierra
    sha256 "a2f1ee0022f260bb6aa102027eb5aebff9c3282bb3a64b5d70efb027c2ce3ee8" => :sierra
    sha256 "be726bed71a569092e003386124b8ef104f190c9fa76f5908f1afda4d467ac42" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
