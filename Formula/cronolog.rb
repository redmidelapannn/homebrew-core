class Cronolog < Formula
  desc "Web log rotation"
  homepage "https://web.archive.org/web/20140209202032/cronolog.org/"
  url "https://fossies.org/linux/www/old/cronolog-1.6.2.tar.gz"
  sha256 "65e91607643e5aa5b336f17636fa474eb6669acc89288e72feb2f54a27edb88e"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "51129ec32ba152c777aaec938508b49ed8e9ad91074c0c90b5ab3bc3c03700ab" => :sierra
    sha256 "b7c008e5e436e45c0cd95a3cb55e0e44c1200e8944fe5c13456f9d75066ce470" => :el_capitan
    sha256 "028390f48e031223d79ba88347d5a6e0369a58f1c590f00e0c655869e8f0fbeb" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
  end
end
