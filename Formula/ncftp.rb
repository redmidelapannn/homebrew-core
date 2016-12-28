class Ncftp < Formula
  desc "FTP client with an advanced user interface"
  homepage "http://www.ncftp.com"
  url "ftp://ftp.ncftp.com/ncftp/ncftp-3.2.6-src.tar.gz"
  sha256 "129e5954850290da98af012559e6743de193de0012e972ff939df9b604f81c23"

  bottle do
    sha256 "70199e4db05dd77686e0256f0c19ac8082b8bf59ec9285df8688fb5d22640d42" => :sierra
    sha256 "8e1bdefb84fcd91f461441d5c45d33536807b0c4fe661c626645cd9ffe04b03a" => :el_capitan
    sha256 "50fb345b28bc8a20d2877d67108f87c9544568de9e27ae7a3545da3af3cb0b35" => :yosemite
    sha256 "07a73c0ac7005566895f7e42f4a1d1b8295a9cdc03ec7986028ae783313e428f" => :mavericks
    sha256 "e59965dc867f70420046475b30829cad0b334bc687e18362918fdfbab7521b59" => :mountain_lion
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
