class RakudoStar < Formula
  desc "Perl 6 compiler"
  homepage "https://rakudo.org/"
  url "https://rakudostar.com/files/star/rakudo-star-2019.03.tar.gz"
  sha256 "640a69de3a2b4f6c49e75a01040e8770de3650ea1d5bb61057e3dfa3c79cc008"

  bottle do
    rebuild 1
    sha256 "4500620a4a9fb5d02b9d95adf84051cbdfc39a4c6d0bc691a802912416ddace1" => :catalina
    sha256 "23061f4946bbfc261ea2d13affd7e5f5019f3b00fa6fa2813be68d6b6b0655ba" => :mojave
    sha256 "846890182374d176eea53d5edc94d28f1810701f3d6f468df38f5c3e411966e3" => :high_sierra
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
