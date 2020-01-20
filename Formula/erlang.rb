class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-22.2.3.tar.gz"
  sha256 "8470fff519d9ffa5defba4e42c3c1e64cd86905313040246d4a6e35799a9e614"
  head "https://github.com/erlang/otp.git"

  bottle do
    cellar :any
    sha256 "24a38cee53feca5bab318400e47acef1f02b25ab4cda2c6614343f37f7658c74" => :catalina
    sha256 "c8a1be48bda4d0045d35416cb702ffce611b44be86638a62d72155fe44071a43" => :mojave
    sha256 "7d26af8807c9ece59adad8c8bf9a33cfa932086ecfa9227d6fedeb405b755aa1" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"
  depends_on "wxmac" # for GUI apps like observer

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_22.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_man_22.1.tar.gz"
    sha256 "64f45909ed8332619055d424c32f8cc8987290a1ac4079269572fba6ef9c74d9"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_22.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_22.1.tar.gz"
    sha256 "3864ac1aa30084738d783d12c241c0a4943cf22a6d1d0f6c7bb9ba0a45ecb9eb"
  end

  def install
    # Work around Xcode 11 clang bug
    # https://bitbucket.org/multicoreware/x265/issues/514/wrong-code-generated-on-macos-1015
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-sctp
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-javac
      --enable-darwin-64bit
    ]

    args << "--enable-kernel-poll" if MacOS.version > :el_capitan
    args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?

    system "./configure", *args
    system "make"
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
