class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2019.07.1/MoarVM-2019.07.1.tar.gz"
  sha256 "253c945ee6b589ede6949b8e77814542befcbc326190e18ef549634db4955988"
  revision 1

  bottle do
    sha256 "e201ea0233902de1651129455b0e74e10a553973af922ed8116dc0cc482f2e1d" => :catalina
    sha256 "e347b7b0d6c95d65fd06643d04565ecd3be66909c9cb8f17046c8c6a6185772e" => :mojave
    sha256 "c9556755c946eb62391a5543bd6f60e7dca10b5b75005e9c44be410c02c1ff60" => :high_sierra
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  resource("nqp-2019.07.1") do
    url "https://github.com/perl6/nqp/releases/download/2019.07.1/nqp-2019.07.1.tar.gz"
    sha256 "7324e5b84903c5063303a3c9fb6205bdf5f071c9778cc695ea746e7d41b12224"
  end

  def install
    libffi = Formula["libffi"]
    ENV.prepend "CPPFLAGS", "-I#{libffi.opt_lib}/libffi-#{libffi.version}/include"
    configure_args = %W[
      --has-libatomic_ops
      --has-libffi
      --has-libtommath
      --has-libuv
      --optimize
      --prefix=#{prefix}
    ]
    system "perl", "Configure.pl", *configure_args
    system "make", "realclean"
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("nqp-2019.07.1")
    out = Dir.chdir("src/vm/moar/stage0") do
      shell_output("#{bin}/moar nqp.moarvm -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    end
    assert_equal "0123456789", out
  end
end
