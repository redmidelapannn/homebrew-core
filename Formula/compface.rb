class Compface < Formula
  desc "Convert to and from the X-Face format"
  homepage "https://web.archive.org/web/20170720045032/freecode.com/projects/compface"
  url "https://mirrorservice.org/sites/ftp.xemacs.org/pub/xemacs/aux/compface-1.5.2.tar.gz"
  mirror "https://ftp.heanet.ie/mirrors/ftp.xemacs.org/aux/compface-1.5.2.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/compface/compface-1.5.2.tar.gz"
  sha256 "a6998245f530217b800f33e01656be8d1f0445632295afa100e5c1611e4f6825"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7a87c7030dd01ca8ac9e7f4b095944bf7d744467d854c984af3e154c018e5115" => :high_sierra
    sha256 "847706e57311b6db22515b3fe685baeadfca4a36969ba06ef4545d440768050c" => :sierra
    sha256 "46d960b743cea8d607c7d2f34665300e79db12efadc7e697f0f22dfba45da1c9" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    system "make", "install"
  end

  test do
    system bin/"uncompface"
  end
end
