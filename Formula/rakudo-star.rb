class RakudoStar < Formula
  desc "Perl 6 compiler"
  homepage "http://rakudo.org/"
  url "https://github.com/rakudo/rakudo/archive/2017.02.tar.gz"
  sha256 "a9a16bef4d826e77d28a2ca7ffe7c1ccde2a236b7ec36a6522e54eb54ac11e85"

  bottle do
    sha256 "0cf6a4a38a413f748ce7e406dca085b3142160e6aded2df0a6919c23a0e1010a" => :sierra
    sha256 "1189fe12704d70e2f6dce2a9c6f671d03345429b834c5aaa7e671bd714804fdc" => :el_capitan
    sha256 "e183cc0842aabb92d34b133ced1a504576789a5de4c65b0547454b0b22f3b715" => :yosemite
  end

  option "with-jvm", "Build also for jvm as an alternate backend."

  depends_on "gmp" => :optional
  depends_on "icu4c" => :optional
  depends_on "pcre" => :optional
  depends_on "libffi"

  conflicts_with "parrot"

  def install
    libffi = Formula["libffi"]
    ENV.remove "CPPFLAGS", "-I#{libffi.include}"
    ENV.prepend "CPPFLAGS", "-I#{libffi.lib}/libffi-#{libffi.version}/include"

    ENV.deparallelize # An intermittent race condition causes random build failures.

    backends = ["moar"]
    generate = ["--gen-moar"]

    backends << "jvm" if build.with? "jvm"

    system "perl", "Configure.pl", "--prefix=#{prefix}", "--backends=" + backends.join(","), *generate
    system "make"
    system "make", "install"

    # Panda is now in share/perl6/site/bin, so we need to symlink it too.
    bin.install_symlink Dir[share/"perl6/site/bin/*"]

    # Move the man pages out of the top level into share.
    # Not all backends seem to generate man pages at this point (moar does not, parrot does),
    # so we need to check if the directory exists first.
    if File.directory?("#{prefix}/man")
      mv "#{prefix}/man", share
    end
  end

  test do
    out = `#{bin}/perl6 -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'`
    assert_equal "0123456789", out
    assert_equal 0, $?.exitstatus
  end
end
