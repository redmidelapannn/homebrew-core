class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2020.01/rakudo-2020.01.tar.gz"
  sha256 "2e02fcfca2f79ec6bd2dc0f0840ae108ec76f030f3080aa47f23f80f92b6c3b0"

  bottle do
    rebuild 1
    sha256 "aae57165a6ae9f3f3f230c44ee01d56f4b4a21a99872dd78c78b243f6697c88b" => :catalina
    sha256 "8b2ec2efb686d8cb61c98b9407f9544f4510e434c57c73be8bba9cc1549892db" => :mojave
    sha256 "b973a05e3aca014bfdb64e6f3731d335c000ac1600bceb463d1d69a3f7f90a8a" => :high_sierra
  end

  depends_on "nqp"

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{Formula["nqp"].bin}/nqp"
    system "make"
    system "make", "install"
    bin.install "tools/install-dist.p6" => "perl6-install-dist"
  end

  test do
    out = shell_output("#{bin}/perl6 -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end
