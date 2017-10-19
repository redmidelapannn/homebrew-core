class Compface < Formula
  desc "Convert to and from the X-Face format"
  homepage "http://freecode.com/projects/compface"
  url "https://mirrorservice.org/sites/ftp.xemacs.org/pub/xemacs/aux/compface-1.5.2.tar.gz"
  mirror "https://ftp.heanet.ie/mirrors/ftp.xemacs.org/aux/compface-1.5.2.tar.gz"
  mirror "http://ftp.xemacs.org/pub/xemacs/aux/compface-1.5.2.tar.gz"
  sha256 "a6998245f530217b800f33e01656be8d1f0445632295afa100e5c1611e4f6825"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f8a7f039a98fc4b03af26fda6f67661f8f46f397cc40365a9f1d62f645216b1a" => :high_sierra
    sha256 "4e6ff11c2c91510cef27c5a601210f5ba01ec8cbcb019efae849d97ab1b4b483" => :sierra
    sha256 "f8e5a783af3c68db85c88bf54e3d954834ceeb40b8466ee3f559ba8b5cec2622" => :el_capitan
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
