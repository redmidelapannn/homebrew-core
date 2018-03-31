class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/thrift/0.11.0/thrift-0.11.0.tar.gz"
  sha256 "c4ad38b6cb4a3498310d405a91fef37b9a8e79a50cd0968148ee2524d2fa60c2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ce71b4b8542d8d35ffc2246690ff8b8e2ff9b8744bb52e7ed3964165931cd870" => :high_sierra
    sha256 "0e8ad561d7d2ca1cff5fe5dab7316a5f25427bf7797e666bdfcd990180d19c21" => :sierra
    sha256 "288cdb4fca4728dca8f09b9ef46455a31f2ad5f1bae473c8090556496f7c73d0" => :el_capitan
  end

  head do
    url "https://git-wip-us.apache.org/repos/asf/thrift.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  option "with-haskell", "Install Haskell binding"
  option "with-erlang", "Install Erlang binding"
  option "with-java", "Install Java binding"
  option "with-perl", "Install Perl binding"
  option "with-php", "Install PHP binding"
  option "with-libevent", "Install nonblocking server libraries"

  deprecated_option "with-python" => "with-python@2"

  depends_on "bison" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "libevent" => :optional
  depends_on "python@2" => :optional

  if build.with? "java"
    depends_on "ant" => :build
    depends_on :java => "1.8"
  end

  def install
    system "./bootstrap.sh" unless build.stable?

    exclusions = ["--without-ruby", "--disable-tests", "--without-php_extension"]

    exclusions << "--without-python" if build.without? "python@2"
    exclusions << "--without-haskell" if build.without? "haskell"
    exclusions << "--without-java" if build.without? "java"
    exclusions << "--without-perl" if build.without? "perl"
    exclusions << "--without-php" if build.without? "php"
    exclusions << "--without-erlang" if build.without? "erlang"

    ENV.cxx11 if MacOS.version >= :mavericks && ENV.compiler == :clang

    # Don't install extensions to /usr:
    ENV["PY_PREFIX"] = prefix
    ENV["PHP_PREFIX"] = prefix
    ENV["JAVA_PREFIX"] = buildpath

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          *exclusions
    ENV.deparallelize
    system "make"
    system "make", "install"

    # Even when given a prefix to use it creates /usr/local/lib inside
    # that dir & places the jars there, so we need to work around that.
    (pkgshare/"java").install Dir["usr/local/lib/*.jar"] if build.with? "java"
  end

  def caveats; <<~EOS
    To install Ruby binding:
      gem install thrift
  EOS
  end

  test do
    system "#{bin}/thrift", "--version"
  end
end
