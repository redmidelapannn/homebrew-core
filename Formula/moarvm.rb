class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://moarvm.org/releases/MoarVM-2019.03.tar.gz"
  sha256 "24b00e5228894fa6f70e9caa73114e5c6ec3686b6305e6e463807a93f70ffc04"

  bottle do
    rebuild 1
    sha256 "6441dc042aca1ee8a5df3ff2905cf8c5c8e1e3c3bc34297b0a09b6195ebeb670" => :mojave
    sha256 "b41d3b2acbc504d900d76e588259c8390ca810b8617d8406cdc16b4b20b8a2e0" => :high_sierra
    sha256 "a2bfed69267989d9dd301896e374a7963c664ac91a4cd2850f22654044c7448c" => :sierra
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  resource("nqp-2019.03") do
    url "https://github.com/perl6/nqp/archive/2019.03.tar.gz"
    sha256 "5f226de8f0567f34797fd1d5eeed1ebf85bbd91f39608f917f48081dd3bf6863"
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
    testpath.install resource("nqp-2019.03")
    out = Dir.chdir("src/vm/moar/stage0") do
      shell_output("#{bin}/moar nqp.moarvm -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    end
    assert_equal "0123456789", out
  end
end
