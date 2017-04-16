class Cln < Formula
  desc "Class Library for Numbers"
  homepage "https://www.ginac.de/CLN/"
  url "https://www.ginac.de/CLN/cln-1.3.4.tar.bz2"
  sha256 "2d99d7c433fb60db1e28299298a98354339bdc120d31bb9a862cafc5210ab748"

  bottle do
    cellar :any
    rebuild 2
    sha256 "3fa6ff1c212900216f8b57948ed708955f3e780b3ccc0520ae3a6addf6853bab" => :sierra
    sha256 "4e17f828147724d85d73937ff56f8c644e6c6f110adcd68f8e3a32b28352029f" => :el_capitan
    sha256 "64e2eb2dc8efd2f99a064b7cfedfec76cad2f41097b044361101926218c2adad" => :yosemite
  end

  option "without-test", "Skip compile-time checks (Not recommended)"

  deprecated_option "without-check" => "without-test"

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    assert_match "3.14159", shell_output("#{bin}/pi 6")
  end
end
