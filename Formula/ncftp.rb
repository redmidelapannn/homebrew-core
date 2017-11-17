class Ncftp < Formula
  desc "FTP client with an advanced user interface"
  homepage "https://www.ncftp.com/"
  url "ftp://ftp.ncftp.com/ncftp/ncftp-3.2.6-src.tar.gz"
  sha256 "129e5954850290da98af012559e6743de193de0012e972ff939df9b604f81c23"

  bottle do
    rebuild 1
    sha256 "dc83ff35d0801abeaecaac10b02ff20b3e1ec7a34c6390c985c37ed06f968cf6" => :high_sierra
    sha256 "0edbaffa997a33026c23a9e5d59d97a895803605291818ca368e50793f90bb92" => :sierra
    sha256 "c11676b8ef2878c521c72571e04b07d03b640a17310b7f78ad23e963e50ba654" => :el_capitan
  end

  def install
    system "./configure", "--disable-universal",
                          "--disable-precomp",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ncftp", "-F"
  end
end
