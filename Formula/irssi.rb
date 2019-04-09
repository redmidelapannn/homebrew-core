class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.2.0/irssi-1.2.0.tar.xz"
  sha256 "1643fca1d8b35e5a5d7b715c9c889e1e9cdb7e578e06487901ea959e6ab3ebe5"

  bottle do
    sha256 "59f0bb1cf582716489fcb17faecaa88006d918060d5277a13370535e8325af06" => :mojave
    sha256 "8e55f584dec44956b89683b814c2a70b477c7b1a164f511448d926d22c8fc1dd" => :high_sierra
    sha256 "5e82c5705cea23ac458870360406f8b1e30490fb0ad98d988e34719da944bd59" => :sierra
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
    # inreplace "configure", "^DUIfm", "^DUIifm"

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
