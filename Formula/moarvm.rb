class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2020.01.1/MoarVM-2020.01.1.tar.gz"
  sha256 "dcb61e44a098e8375c385eb9d52bd6394255a388697b2f6a52d88e6cf4a53587"

  bottle do
    rebuild 1
    sha256 "8db035ce31f8747cf0db283edd3643caad5ddfc8d9c36a9c808b35a6089ebba6" => :catalina
    sha256 "d59f8135f69d6e8660eb9c1c8453f9b20d08d4dcb8d499b13d45dcca481f46e2" => :mojave
    sha256 "df947e65628a7a7b06f85727ddafad540de086641ac16d7f9257d1e398293a50" => :high_sierra
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  conflicts_with "rakudo-star", :because => "rakudo-star currently ships with moarvm included"

  resource("nqp") do
    url "https://github.com/perl6/nqp/releases/download/2020.01/nqp-2020.01.tar.gz"
    sha256 "4ccc9c194322c73f4c8ba681e277231479fcc2307642eeeb0f7caa149332965b"
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
    testpath.install resource("nqp")
    out = Dir.chdir("src/vm/moar/stage0") do
      shell_output("#{bin}/moar nqp.moarvm -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    end
    assert_equal "0123456789", out
  end
end
