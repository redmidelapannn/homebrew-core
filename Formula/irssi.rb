class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.1.1/irssi-1.1.1.tar.xz"
  sha256 "784807e7a1ba25212347f03e4287cff9d0659f076edfb2c6b20928021d75a1bf"

  bottle do
    rebuild 2
    sha256 "7f350f61014d493bd449b01ada0e6b0f4f2e7e8e70668a6fc14da8832326e500" => :mojave
    sha256 "44c7f1071df61d6120aede9e29bd6ee3c90aea69651ab7d8b1a8b0ff82f37f82" => :high_sierra
    sha256 "d511ed558f3ae91f0bc5a9bf50de8cf6180ffaf125af8c8c3a4d5c5e17873fa7" => :sierra
  end

  head do
    url "https://github.com/irssi/irssi.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "lynx" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-bot
      --with-proxy
      --enable-true-color
      --with-socks=no
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
