class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "http://xmlsoft.org/sources/libxslt-1.1.32.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/libxslt/libxslt-1.1.32.tar.gz"
  sha256 "526ecd0abaf4a7789041622c3950c0e7f2c4c8835471515fd77eec684a355460"

  bottle do
    rebuild 1
    sha256 "32427b398fad64453d66fb2ccaab0013057f99e52975e1b41b67762242dc2dde" => :mojave
    sha256 "a70d7d050c81dc53ff6d87d4105fa87c7165c762c7b52cc6586dbdd30ec496d6" => :high_sierra
    sha256 "788239694aee418fbbb71a6d0b6bc3f7acce93d4c5c41adb06b0ee1badb70f99" => :sierra
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxslt.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "libxml2"

  def install
    system "autoreconf", "-fiv" if build.head?

    # https://bugzilla.gnome.org/show_bug.cgi?id=762967
    inreplace "configure", /PYTHON_LIBS=.*/, 'PYTHON_LIBS="-undefined dynamic_lookup"'

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-libxml-prefix=#{Formula["libxml2"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  def caveats; <<~EOS
    To allow the nokogiri gem to link against this libxslt run:
      gem install nokogiri -- --with-xslt-dir=#{opt_prefix}
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xslt-config --version")
  end
end
