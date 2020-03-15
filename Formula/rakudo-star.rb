class RakudoStar < Formula
  desc "Perl 6 compiler"
  homepage "https://rakudo.org/"
  url "https://rakudo.org/dl/star/rakudo-star-2020.01.tar.gz"
  sha256 "f1696577670d4ff5b464e572b1b0b8c390e6571e1fb8471cbf369fa39712c668"
  revision 1

  bottle do
    sha256 "d2ef8d71c02d6d92fec29d740a97410dbe94f758fd81e1ca29f35210c917d263" => :catalina
    sha256 "6de46f1f6175f0d282a025f54863607a6ed7d32074ef2354053f87bbc93b8631" => :mojave
    sha256 "dfd07e48a1a607d21ad3222b8ae53642195c93a1f5acc56a8394e939bf167280" => :high_sierra
  end

  depends_on "gmp"
  depends_on "icu4c"
  depends_on "libffi"
  depends_on "pcre"

  conflicts_with "moarvm", "nqp", :because => "rakudo-star currently ships with moarvm and nqp included"
  conflicts_with "parrot"
  conflicts_with "rakudo"

  def install
    libffi = Formula["libffi"]
    ENV.remove "CPPFLAGS", "-I#{libffi.include}"
    ENV.prepend "CPPFLAGS", "-I#{libffi.lib}/libffi-#{libffi.version}/include"

    ENV.deparallelize # An intermittent race condition causes random build failures.

    system "perl", "Configure.pl", "--prefix=#{prefix}",
                   "--backends=moar", "--gen-moar"
    system "make"
    # make install runs tests that can hang on sierra
    # set this variable to skip those tests
    ENV["NO_NETWORK_TESTING"] = "1"
    system "make", "install"

    # Panda is now in share/perl6/site/bin, so we need to symlink it too.
    bin.install_symlink Dir[share/"perl6/site/bin/*"]

    # Move the man pages out of the top level into share.
    # Not all backends seem to generate man pages at this point (moar does not, parrot does),
    # so we need to check if the directory exists first.
    mv "#{prefix}/man", share if File.directory?("#{prefix}/man")
  end

  test do
    out = `#{bin}/perl6 -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'`
    assert_equal "0123456789", out
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
