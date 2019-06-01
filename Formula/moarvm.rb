class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://moarvm.org/releases/MoarVM-2019.05.tar.gz"
  sha256 "fa281fe3b174399820ddc21a569cb9a3b9ca374f0959b33f28273e567bc4d182"

  bottle do
    sha256 "da117d382c6a8b7f5360a57db83d11ed167bcdde62092e355d064b9131352307" => :mojave
    sha256 "a19393e14e93b7ed595637b895c886b74ad7af1989e3131536f48999b747afbb" => :high_sierra
    sha256 "396771f1a17a5d7ce7e0defb37bbd109537c1a4f1bbc3734bb88a5a2f2ed40ac" => :sierra
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
