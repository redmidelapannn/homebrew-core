class Less < Formula
  desc "Pager program similar to more"
  homepage "http://www.greenwoodsoftware.com/less/index.html"
  url "http://www.greenwoodsoftware.com/less/less-535.tar.gz"
  sha256 "4cf29238841e01fef74eb9d692f64f3d55cad3eaed6d8d3649a82fee901e8eba"

  bottle do
    prefix "/usr/local"
    cellar "/usr/local/Cellar"
    sha256 "351ecad534661558048072d225e43b2cfc3d9a8576f1d5fbeeb5b2747529eb6f" => :mojave
    sha256 "eb595acf63df29c2ea275c4564ee1c290add243238dc5acf8bfe884efa75ff85" => :high_sierra
    sha256 "407d14a01ee8af7f07bcc6cc116d32d5b3dfb39ce370e80f248b365ca1befc1c" => :sierra
    sha256 "8c8a5276bc498eeeaa0903a03fe10aca1ccda17188d38d294f89446ca2e3a8ad" => :el_capitan
  end

  depends_on "pcre" => :optional

  def install
    args = ["--prefix=#{prefix}"]
    args << "--with-regex=pcre" if build.with? "pcre"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/lesskey", "-V"
  end
end
