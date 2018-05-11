class Syck < Formula
  desc "Extension for reading and writing YAML"
  homepage "https://wiki.github.com/indeyets/syck/"
  url "https://github.s3.amazonaws.com/downloads/indeyets/syck/syck-0.70.tar.gz"
  sha256 "4c94c472ee8314e0d76eb2cca84f6029dc8fc58bfbc47748d50dcb289fda094e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6149d820012482065e9dcc32326c5d209a271f321edb7b88b1f3bf947fa3720a" => :high_sierra
    sha256 "08fc15e32b3bc080b8d7b11acfd65b4c873e3a9de1049f0a7fdad60c2e7a75ee" => :sierra
    sha256 "deff89b282fac47bcea98247cfd9c72b03cfd1ece6134d2a4de6fb19d935d66e" => :el_capitan
  end

  def install
    ENV.deparallelize # Not parallel safe.
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
