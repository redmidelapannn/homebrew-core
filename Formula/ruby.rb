class Ruby < Formula
  desc "Next-generation Perl"
  homepage "http://rakudo.org/"
  url "https://rakudo.perl6.org/downloads/star/rakudo-star-2018.01.tar.gz"
  sha256 "8f0290f409307c45a107360e7883f2fad3c19aa995133ab53e6f36ae9452d351"

  bottle do
    sha256 "176e02f1a6382ad076a2c57f3f400b90f802d4e75c190f6b882609d26d6c7ad2" => :high_sierra
    sha256 "8fcca2a7f9e2bd4fbb5d3ddf33c47c8728fd4fe00cf25410ee82f4a2660fe39a" => :sierra
    sha256 "5d8f1e990ad517d95addeafebdddcc1bffa9a2bf5204b16fc792128d75287f11" => :el_capitan
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
    mv "#{prefix}/man", share if File.directory?("#{prefix}/man")
  end

  test do
    out = `#{bin}/perl6 -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'`
    assert_equal "0123456789", out
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
