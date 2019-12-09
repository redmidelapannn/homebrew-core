class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2019.11/MoarVM-2019.11.tar.gz"
  sha256 "d882c5114e35800eba2226f2104997052e98b3efdea6463e7edb213a87870201"

  bottle do
    sha256 "22b33e48ba131021e98f367fc30c9405f40ffdd6c7c164404e121a87b0d95686" => :catalina
    sha256 "0511f43013322174d3252170dea24dc44fb8cf09e9c5b5903b55b290381704a8" => :mojave
    sha256 "03057a8f883d96b9d13baaec148b76d849ab5d742e168ac7262738402c1c356f" => :high_sierra
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  resource("nqp-2019.11") do
    url "https://github.com/perl6/nqp/releases/download/2019.11/nqp-2019.11.tar.gz"
    sha256 "b47f911def8aafded041b079ac86e5df23b726c190664c3217c567835f481328"
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
    testpath.install resource("nqp-2019.11")
    out = Dir.chdir("src/vm/moar/stage0") do
      shell_output("#{bin}/moar nqp.moarvm -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    end
    assert_equal "0123456789", out
  end
end
