class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2020.02.1/rakudo-2020.02.1.tar.gz"
  sha256 "7bb27366c0fe7dfd4c5bd616903208a6d63d71f420d14ec0ffa661ca1c8ecae1"
  revision 1

  bottle do
    sha256 "e33ebb24f51367e114e7e77a7a14a2f6040e50c220fdf5091d29648c37168436" => :catalina
    sha256 "9fa2d19fe6281475ff26178bab7a9193a3ac3eb45cda4fb5f6e9f0daaef2d211" => :mojave
    sha256 "c8d7af71a470d3263368cbf1741fcb04e619e8873e4df782be1443eebe6e2cce" => :high_sierra
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
