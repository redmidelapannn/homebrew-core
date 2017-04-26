class ThriftAT09 < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/thrift/0.9.3/thrift-0.9.3.tar.gz"
  sha256 "b0740a070ac09adde04d43e852ce4c320564a292f26521c46b78e0641564969e"

  bottle do
    cellar :any
    sha256 "5a1ebc57408ba896ccb867d13f357ed4df6c04ef36656ea7d30cdf133637464e" => :sierra
    sha256 "41dc74f549d54af1aafe78a6af6f2a97fcdcbe83133f5a92d7ca703968a1052f" => :el_capitan
    sha256 "7f13c2f5599ee3c02d2608b92904b2439e1cb849cbb7c8b5ac2d0308226b035e" => :yosemite
  end

  keg_only :versioned_formula

  option "with-haskell", "Install Haskell binding"
  option "with-erlang", "Install Erlang binding"
  option "with-java", "Install Java binding"
  option "with-perl", "Install Perl binding"
  option "with-php", "Install PHP binding"
  option "with-libevent", "Install nonblocking server libraries"

  depends_on "bison" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "libevent" => :optional
  depends_on :python => :optional

  def install
    system "./bootstrap.sh" unless build.stable?

    exclusions = ["--without-ruby", "--disable-tests", "--without-php_extension"]

    exclusions << "--without-python" if build.without? "python"
    exclusions << "--without-haskell" if build.without? "haskell"
    exclusions << "--without-java" if build.without? "java"
    exclusions << "--without-perl" if build.without? "perl"
    exclusions << "--without-php" if build.without? "php"
    exclusions << "--without-erlang" if build.without? "erlang"

    ENV.cxx11 if MacOS.version >= :mavericks && ENV.compiler == :clang

    # Don't install extensions to /usr:
    ENV["PY_PREFIX"] = prefix
    ENV["PHP_PREFIX"] = prefix

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          *exclusions
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    To install Ruby binding:
      gem install thrift

    To install PHP extension for e.g. PHP 5.5:
      brew install homebrew/php/php55-thrift
  EOS
  end

  test do
    assert_match /Thrift/, shell_output("#{bin}/thrift --version", 0)
    assert_match /0\.9\.3/, shell_output("#{bin}/thrift --version", 0)
  end
end
