class Compface < Formula
  desc "Convert to and from the X-Face format"
  homepage "http://freecode.com/projects/compface"
  url "https://mirrorservice.org/sites/ftp.xemacs.org/pub/xemacs/xemacs/tux/xemacs/aux/compface-1.5.2.tar.gz"
  mirror "https://ftp.heanet.ie/mirrors/ftp.xemacs.org/aux/compface-1.5.2.tar.gz"
  mirror "ftp://ftp.xemacs.org/pub/xemacs/aux/compface-1.5.2.tar.gz"
  sha256 "a6998245f530217b800f33e01656be8d1f0445632295afa100e5c1611e4f6825"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8175d2e40ce02b259b817eaed8f68ceb95596f4034899ee792b751739ecc1fd7" => :sierra
    sha256 "4b5f9eef29aebb6b7f1d60c172fc37a18664144f4e13e94309a007d3091f19fc" => :el_capitan
    sha256 "40e3fcda9460192018a721642d5c4ce7c7c75a1ebdbf6d888d0e5eb51dbb18ab" => :yosemite
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
