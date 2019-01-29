class ErlangAT17 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  url "https://github.com/erlang/otp/archive/OTP-17.5.6.10.tar.gz"
  sha256 "ceea65d9326a3a0324b4963a982c610692c087ab23eaf637a626370dfb81fe50"

  bottle do
    cellar :any
    rebuild 1
    sha256 "aea261cb91cc90ca8598081ed974914989a42d22a6793c3a684fa4183fb96a16" => :mojave
    sha256 "539a1ec6f2e8abe3a84a4fa3810adaa064135e4e073a520c1eb46a0122331a14" => :high_sierra
    sha256 "867f2d64830f2513e9e6bc39ec595335a506766f8112d491392269d975963288" => :sierra
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "unixodbc"
  depends_on "wxmac"

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_17.5.tar.gz"
    sha256 "85b1b2a1011fc01af550f1fe9e5a599a4c5f2a35d264d2804af1d05590a857c3"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_17.5.tar.gz"
    sha256 "baba1d373c1faacf4a1a6ec1220d57d0cb2b977edb74f32cd58dc786361c6cf5"
  end

  # Erlang will crash on macOS 10.13 any time the crypto lib is used.
  # The Erlang team has an open PR for the patch but it needs to be applied to
  # older releases. See https://github.com/erlang/otp/pull/1501 and
  # https://bugs.erlang.org/browse/ERL-439 for additional information.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/8cf3045/erlang%4017/boring-ssl-high-sierra.patch"
    sha256 "ec4bbdabdfece3a273210727bc150e0e588479885a141382b4d54221bbec5fc3"
  end

  # Pointer comparison triggers error with Xcode 9
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://github.com/erlang/otp/commit/a64c4d806fa54848c35632114585ad82b98712e8.diff?full_index=1"
      sha256 "3261400f8d7f0dcff3a52821daea3391ebfa01fd859f9f2d9cc5142138e26e15"
    end
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

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
      --enable-hipe
      --enable-shared-zlib
      --enable-smp-support
      --enable-wx
      --enable-darwin-64bit
    ]

    args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?

    system "./configure", *args
    system "make"
    ENV.deparallelize # Install is not thread-safe; can try to create folder twice and fail
    system "make", "install"

    (lib/"erlang").install resource("man").files("man")
    doc.install resource("html")
  end

  def caveats; <<~EOS
    Man pages can be found in:
      #{opt_lib}/erlang/man

    Access them with `erl -man`, or add this directory to MANPATH.
  EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
  end
end
