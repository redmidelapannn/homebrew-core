class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.26.0.tar.gz"
  sha256 "ebe7c66906d4fb55449380ab1b7e004eeef52c38d3443fa301f8e17a1a4cb67f"
  head "https://perl5.git.perl.org/perl.git", :branch => "blead"

  bottle do
    sha256 "af578c645e5ff6162b29c693c6145345fef4dfc848f9d999a6e1f36330318c63" => :sierra
    sha256 "c66b2d1daf5e4d77b8f4943b9718610c6d24d20537e6a1b6a87ccf74fd54ec02" => :el_capitan
    sha256 "3474d4c2ddf177e331d70af4dbe1f51199139e525add8424b43b6339358950ab" => :yosemite
  end

  option "with-dtrace", "Build with DTrace probes"
  option "without-test", "Skip running the build test suite"

  deprecated_option "with-tests" => "with-test"

  def install
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      %w[cpan/IPC-Cmd/lib/IPC/Cmd.pm dist/Time-HiRes/Changes
         dist/Time-HiRes/HiRes.pm dist/Time-HiRes/HiRes.xs
         dist/Time-HiRes/Makefile.PL dist/Time-HiRes/fallback/const-c.inc
         dist/Time-HiRes/t/clock.t pod/perl588delta.pod
         pod/perlperf.pod].each do |f|
        inreplace f do |s|
          s.gsub! "clock_gettime", "perl_clock_gettime"
          s.gsub! "clock_getres", "perl_clock_getres", false
        end
      end
    end

    # We don't want the build process to go snooping around externally
    # for things like the `Test` perl module.
    ENV.delete("PERL5LIB")

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

    args << "-Dusedtrace" if build.with? "dtrace"
    args << "-Dusedevel" if build.head?

    system "./Configure", *args
    system "make"

    # OS X El Capitan's SIP feature prevents DYLD_LIBRARY_PATH from being
    # passed to child processes, which causes the make test step to fail.
    # https://rt.perl.org/Ticket/Display.html?id=126706
    # https://github.com/Homebrew/legacy-homebrew/issues/41716
    if MacOS.version < :el_capitan
      system "make", "test" if build.with? "test"
    end

    system "make", "install"
  end

  def caveats; <<-EOS.undent
    By default non-brewed cpan modules are installed to the Cellar. If you wish
    for your modules to persist across updates we recommend using `local::lib`.

    You can set that up like this:
      PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
      echo 'eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"' >> #{Utils::Shell.profile}
    EOS
  end

  test do
    phrase = "Perl is not an acronym, but JAPH is a Perl acronym!"
    (testpath/"test.pl").write "print '#{phrase}';"
    assert_match phrase, shell_output("#{bin}/perl test.pl")
  end
end
