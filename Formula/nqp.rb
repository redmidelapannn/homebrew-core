class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  url "https://github.com/perl6/nqp/releases/download/2019.11/nqp-2019.11.tar.gz"
  sha256 "b47f911def8aafded041b079ac86e5df23b726c190664c3217c567835f481328"

  bottle do
    sha256 "a916b341abb5b341a9c07dc3bff5e402e5079efd729fdd2bcd573ffd18da60a5" => :catalina
    sha256 "e94b2df689271f1bbbdceaceb78ebddb9e589b043da463bb7d561e6b50b5886b" => :mojave
    sha256 "cc38bb359af3730690490e13e0288ce7e2b426dcf04b11ec1d1caebbcd075158" => :high_sierra
  end

  depends_on "moarvm"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}/moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end
