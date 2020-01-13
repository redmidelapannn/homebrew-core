class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2019.07.1/rakudo-2019.07.1.tar.gz"
  sha256 "d91dce95ec3f6fca1723c7eacfcbcc823269ba73dc945d778f608f0c878444f7"
  revision 1

  bottle do
    sha256 "bb504bc7e5665014ad7fe83bb6b082c754c5e5da15236199f6529214207a7c35" => :mojave
  end

  depends_on "nqp"

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
