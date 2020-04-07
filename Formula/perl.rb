class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.30.2.tar.gz"
  sha256 "66db7df8a91979eb576fac91743644da878244cf8ee152f02cd6f5cd7a731689"
  head "https://github.com/perl/perl5.git", :branch => "blead"

  bottle do
    sha256 "00ca324c529bbbce22f3f483ad1a8b4543b2c0ea59f363d40aa6b209569c1a07" => :catalina
    sha256 "585728411c3c70847ce3bfc03b4b8c28735857f6475d74f6683f853dc82c7b88" => :mojave
    sha256 "54fb6763461f82698b31fb7eea4d0da40899f7afcc43ab2f1c0e55961b1b59cf" => :high_sierra
  end

  uses_from_macos "expat"

  # Prevent site_perl directories from being removed
  skip_clean "lib/perl5/site_perl"

  def install
    args = %W[
      -des
      -Dprefix=#{prefix}
      -Dprivlib=#{lib}/perl5/#{version}
      -Dsitelib=#{lib}/perl5/site_perl/#{version}
      -Dotherlibdirs=#{HOMEBREW_PREFIX}/lib/perl5/site_perl/#{version}
      -Dperlpath=#{opt_bin}/perl
      -Dstartperl=#!#{opt_bin}/perl
      -Dman1dir=#{man1}
      -Dman3dir=#{man3}
      -Duseshrplib
      -Duselargefiles
      -Dusethreads
    ]

    args << "-Dusedevel" if build.head?

    system "./Configure", *args

    system "make"

    system "make", "install"
  end

  def caveats
    <<~EOS
      By default non-brewed cpan modules are installed to the Cellar. If you wish
      for your modules to persist across updates we recommend using `local::lib`.

      You can set that up like this:
        PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
        echo 'eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"' >> #{shell_profile}
    EOS
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system "#{bin}/perl", "test.pl"
  end
end
