class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  head "https://perl5.git.perl.org/perl.git", :branch => "blead"

  stable do
    url "http://www.cpan.org/src/5.0/perl-5.24.1.tar.xz"
    sha256 "03a77bac4505c270f1890ece75afc7d4b555090b41aa41ea478747e23b2afb3f"

    # Fixes Time::HiRes module bug related to the presence of clock_gettime
    # https://rt.perl.org/Public/Bug/Display.html?id=128427
    # Merged upstream, should be in the next release.
    if DevelopmentTools.clang_build_version >= 800
      patch do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/b18137128c4e0cb7e92e9ee007a9f78bc9d03b21/perl/clock_gettime.patch"
        sha256 "612825c24ed19d6fa255bb42af59dff46ee65c16ea77abf4a59b754aa8ab05ac"
      end
    end
  end

  bottle do
    rebuild 1
    sha256 "d15d2ef26e71092d8487d6abec737f28d484e88f5db2df352db35c98c30dac6b" => :sierra
    sha256 "85560b493967c34e5e801af46bc8bee1312689a877c032f4d1bb841068b88267" => :el_capitan
    sha256 "d74e8bbb61b4f8dfff945a7c37b46bc411aed46faae9ad2135caab00a4e97bcd" => :yosemite
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
      echo 'eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"' >> #{shell_profile}
    EOS
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system "#{bin}/perl", "test.pl"
  end
end
