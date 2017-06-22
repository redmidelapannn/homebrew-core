class ErlangAT18 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  url "https://github.com/erlang/otp/archive/OTP-18.3.4.tar.gz"
  sha256 "d9e68a8cdef4db0935b02d4b163cf3af403405f756488874736298cf48b90ae9"
  head "https://github.com/erlang/otp.git", :branch => "maint-18"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b66d4dbd9620340de3f1aff330c061406f74a4cdd23c96703060acca4a221eb5" => :sierra
    sha256 "c30a8a2d13f193b8fe87654f1566dd0252de677cf02e16d20f66145513326f2d" => :el_capitan
    sha256 "4bae08d4143879a137df7646359bb08783a4607a47123c7c03e2f73f10189c0b" => :yosemite
  end

  keg_only :versioned_formula

  option "without-hipe", "Disable building hipe; fails on various macOS systems"
  option "with-native-libs", "Enable native library compilation"
  option "with-dirty-schedulers", "Enable experimental dirty schedulers"
  option "with-java", "Build jinterface application"
  option "without-docs", "Do not install documentation"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "fop" => :optional # enables building PDF docs
  depends_on :java => :optional
  depends_on "wxmac" => :recommended # for GUI apps like observer

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_18.3.tar.gz"
    sha256 "978be100e9016874921b3ad1a65ee46b7b6a1e597b8db2ec4b5ef436d4c9ecc2"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_18.3.tar.gz"
    sha256 "8fd6980fd05367735779a487df107ace7c53733f52fbe56de7ca7844a355676f"
  end

  def install
    # Fixes "dyld: Symbol not found: _clock_gettime"
    # Reported 17 Sep 2016 https://bugs.erlang.org/browse/ERL-256
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      ENV["erl_cv_clock_gettime_monotonic_default_resolution"] = "no"
      ENV["erl_cv_clock_gettime_monotonic_try_find_pthread_compatible"] = "no"
      ENV["erl_cv_clock_gettime_wall_default_resolution"] = "no"
    end

    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    ENV["FOP"] = "#{HOMEBREW_PREFIX}/bin/fop" if build.with? "fop"

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-kernel-poll
      --enable-threads
      --enable-sctp
      --enable-dynamic-ssl-lib
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --enable-shared-zlib
      --enable-smp-support
    ]

    args << "--enable-darwin-64bit" if MacOS.prefer_64_bit?
    args << "--enable-native-libs" if build.with? "native-libs"
    args << "--enable-dirty-schedulers" if build.with? "dirty-schedulers"
    args << "--enable-wx" if build.with? "wxmac"
    args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?

    if build.without? "hipe"
      # HIPE doesn't strike me as that reliable on macOS
      # https://syntatic.wordpress.com/2008/06/12/macports-erlang-bus-error-due-to-mac-os-x-1053-update/
      # https://www.erlang.org/pipermail/erlang-patches/2008-September/000293.html
      args << "--disable-hipe"
    else
      args << "--enable-hipe"
    end

    if build.with? "java"
      args << "--with-javac"
    else
      args << "--without-javac"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize # Install is not thread-safe; can try to create folder twice and fail
    system "make", "install"

    if build.with? "docs"
      (lib/"erlang").install resource("man").files("man")
      doc.install resource("html")
    end
  end

  def caveats; <<-EOS.undent
    Man pages can be found in:
      #{opt_lib}/erlang/man
    Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
  end
end
