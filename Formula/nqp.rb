class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  url "https://github.com/perl6/nqp/releases/download/2020.01/nqp-2020.01.tar.gz"
  sha256 "4ccc9c194322c73f4c8ba681e277231479fcc2307642eeeb0f7caa149332965b"

  bottle do
    rebuild 1
    sha256 "571ea8942a500b7cf855255b66f043a59d9272c6e8ba81f8a6923ca8999f4e40" => :catalina
    sha256 "f0968c795be07040adcadcaedf03fd0849ea77de76d3b78d4a50dc16dd2c055d" => :mojave
    sha256 "75dd136a7dfee5a12eeffa1871b8558cb13cb602a538b3a08248361156ff0e50" => :high_sierra
  end

  depends_on "moarvm"

  conflicts_with "rakudo-star", :because => "rakudo-star currently ships with nqp included"

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
