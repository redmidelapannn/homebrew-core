class LibpokerEval < Formula
  desc "C library to evaluate poker hands"
  homepage "https://pokersource.sourceforge.io/"
  # http://download.gna.org/pokersource/sources/poker-eval-138.0.tar.gz is offline
  url "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/p/poker-eval/poker-eval_138.0.orig.tar.gz"
  sha256 "92659e4a90f6856ebd768bad942e9894bd70122dab56f3b23dd2c4c61bdbcf68"

  bottle do
    cellar :any
    rebuild 2
    sha256 "f06be2069591f7ee87e877d6d1407c433b26bef07c300bb0706028a3caa94d48" => :high_sierra
    sha256 "60fc4fa6fd05d5a4bd7f0366b0a4a91118b85d253ecd284ccdb46939f7cef5e3" => :sierra
    sha256 "b58dc974e6a34fafb2e471aca8613afa53fcf817f890fa4b739751f0e10a397a" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
