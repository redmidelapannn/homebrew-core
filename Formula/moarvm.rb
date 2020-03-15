class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2020.02.1/MoarVM-2020.02.1.tar.gz"
  sha256 "82cb80b29ad7aebb0c0b42449d371eafa8935b07884526345f9788c8bcf4d632"
  revision 1

  bottle do
    sha256 "9d250bfb3fd24bf8e9eadda0b2ed1b506dfaffe9f93e5a4be6f268181b735194" => :catalina
    sha256 "11552530ff5ce2a8e1342b674e17807d8056cf98ca40d00a5bee5cd95bf912f4" => :mojave
    sha256 "3cdf51fe945543e75f157858d29abc5c9e51f58b48b7db1f7f8e37cf4450274a" => :high_sierra
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  conflicts_with "rakudo-star", :because => "rakudo-star currently ships with moarvm included"

  resource("nqp") do
    url "https://github.com/perl6/nqp/releases/download/2020.02.1/nqp-2020.02.1.tar.gz"
    sha256 "f2b5757231b006cfb440d511ccdcfc999bffabe05c51e0392696601ff779837f"
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
