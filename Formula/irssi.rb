class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.2.1/irssi-1.2.1.tar.xz"
  sha256 "5466a1ed9612cfa707d9a37d60b29d027b4ac7d83c74ceb1a410e2b59edba92c"

  bottle do
    rebuild 1
    sha256 "8fbdf8cedb8d1ac06ba08bfb6a3c4b1eb42ab15be2b90272e9f9d598e29054bc" => :mojave
    sha256 "0e16877641b6f61ea090604d719c45b4d959045e9d80f7a861aff63169382a89" => :high_sierra
    sha256 "7dcf39b394c18f501fed4a0fbee4e071dd2cfa7af81d7d33a617d0ddca3e34dd" => :sierra
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
  uses_from_macos "perl"

  def install
    ENV.delete "HOMEBREW_SDKROOT" if MacOS.version == :high_sierra

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
    # To debug a Perl problem copy the following test at the end of the install
    # block to surface the relevant information from the build warnings.
    ENV["PERL5LIB"] = lib/"perl5/site_perl"
    system "perl", "-e", "use Irssi"
  end
end
