class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://live.gnome.org/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/9.0/gucharmap-9.0.4.tar.xz"
  sha256 "1588b2b183b843b24eb074fd0661bddb54f18876870ba475d65f35b7a9c677a0"

  bottle do
    rebuild 1
    sha256 "000fa2a63c360abd9375bd84cdd2087394579f060d53f928d5cd675f741f1590" => :sierra
    sha256 "506def308fb9f98ac96d86ae61cce8c3202b7bcee139f8763d20b5fe75d60c26" => :el_capitan
    sha256 "3ca74e34793292f67de3487c2d1472e35e409253313cf4167fb3efd74cd275d6" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "desktop-file-utils" => :build
  depends_on "coreutils" => :build
  depends_on "gtk+3"

  def install
    ENV["WGET"] = "curl"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic",
                          "--disable-schemas-compile",
                          "--enable-introspection=no",
                          "--with-unicode-data=download"
    system "make", "WGETFLAGS=--remote-name --remote-time --connect-timeout 30 --retry 8"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/gucharmap", "--version"
  end
end
