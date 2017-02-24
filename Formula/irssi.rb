class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.0.1/irssi-1.0.1.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/irssi/irssi_1.0.1.orig.tar.xz"
  sha256 "9428c51a3f3598ffaef438c351a8d609cf10db34f2435bdcb84456226c383ccf"

  bottle do
    rebuild 1
    sha256 "4c4a9d4d1e7d3960f878f9f05af2a0265076ae977cf99bc9c425e7190790ef1a" => :sierra
    sha256 "67d789fce5a6116863afce6e7c980c44e8e00da1d3a29837784bf0f2536df9bc" => :el_capitan
    sha256 "6fdea1272a21bccf5e61b3f21ea2689539253cd021388a3fcc9b72b284f89bc6" => :yosemite
  end

  head do
    url "https://github.com/irssi/irssi.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "lynx" => :build
  end

  option "with-dante", "Build with SOCKS support"
  option "without-perl", "Build without perl support"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl" => :recommended
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
    ]

    if build.with? "perl"
      args << "--with-perl=yes"
      args << "--with-perl-lib=#{lib}/perl5/site_perl"
    else
      args << "--with-perl=no"
    end

    args << "--disable-ssl" if build.without? "openssl"

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    # "make" and "make install" must be done separately on some systems
    system "make"
    system "make", "install"
  end

  test do
    IO.popen("#{bin}/irssi --connect=irc.freenode.net", "w") do |pipe|
      pipe.puts "/quit\n"
      pipe.close_write
    end
  end
end
