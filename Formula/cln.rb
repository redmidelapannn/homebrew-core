class Cln < Formula
  desc "Class Library for Numbers"
  homepage "https://www.ginac.de/CLN/"
  url "https://www.ginac.de/CLN/cln-1.3.4.tar.bz2"
  sha256 "2d99d7c433fb60db1e28299298a98354339bdc120d31bb9a862cafc5210ab748"

  bottle do
    cellar :any
    rebuild 2
    sha256 "44f3adc07d2554ac1ec9f5c1dc70ded373a12f5785aaa27acd0dcd4b452b30e9" => :mojave
    sha256 "d72de6f6f81da0bf70a268a047342b0bee58a9e34e3479a8acdf888907238c82" => :high_sierra
    sha256 "7bccb975ae4bff3a0cdfeb7122f097c98b2c4d406192656cc0886233f1d2de6e" => :sierra
    sha256 "7d8a4fba329eecdbb9a07c87ba603e580f3c13d13be2da348f773dbd23e2dd78" => :el_capitan
  end

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match "3.14159", shell_output("#{bin}/pi 6")
  end
end
