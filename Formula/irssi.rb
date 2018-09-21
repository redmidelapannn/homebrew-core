class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.1.1/irssi-1.1.1.tar.xz"
  sha256 "784807e7a1ba25212347f03e4287cff9d0659f076edfb2c6b20928021d75a1bf"

  bottle do
    rebuild 2
    sha256 "f6c35f75771bc066f718b505a31cf38001216342ef942a316a37493dba896af8" => :mojave
    sha256 "bc6c1a382fe2776d6586ec18e2f55b437cb9fac6b780d08a520c76a52071d894" => :high_sierra
    sha256 "a9be01a9d8a09580fb35f6b3c1c14e26c0fe8bdafe4ae305ab9094750fac00fe" => :sierra
    sha256 "1845627c0103b5c5b73613e9c80806092695c0a1e811c9e243186e74091121c3" => :el_capitan
  end

  head do
    url "https://github.com/irssi/irssi.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "lynx" => :build
  end

  option "with-dante", "Build with SOCKS support"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl"
  depends_on "dante" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-bot
      --with-proxy
      --enable-true-color
      --with-socks=#{build.with?("dante") ? "yes" : "no"}
      --with-ncurses=#{MacOS.sdk_path}/usr
      --with-perl=yes
      --with-perl-lib=#{lib}/perl5/site_perl
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh", *args
    end

    # https://github.com/irssi/irssi/pull/927
    inreplace "configure", "^DUIfm", "^DUIifm"

    system "./configure", *args
    # "make" and "make install" must be done separately on some systems
    system "make"
    system "make", "install"
  end

  test do
    IO.popen("#{bin}/irssi --connect=irc.freenode.net", "w") do |pipe|
      pipe.puts "/quit\n"
      pipe.close_write
    end

    # This is not how you'd use Perl with Irssi but it is enough to be
    # sure the Perl element didn't fail to compile, which is needed
    # because upstream treats Perl build failures as non-fatal.
    ENV["PERL5LIB"] = lib/"perl5/site_perl"
    system "perl", "-e", "use Irssi"
  end
end
