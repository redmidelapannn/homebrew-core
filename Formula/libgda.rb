class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "http://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/5.2/libgda-5.2.4.tar.xz"
  sha256 "2cee38dd583ccbaa5bdf6c01ca5f88cc08758b9b144938a51a478eb2684b765e"
  revision 2

  bottle do
    rebuild 1
    sha256 "86048e42c5ab58942e064a3f83261dd259a31c7ddc91365f79e1aeb36764d860" => :high_sierra
    sha256 "18a166200166e02e200a19c8f6a3c5122f08032f27d2fecdf4677ba7e4ea8a67" => :sierra
    sha256 "ee60937a6e8a2883955c86a8aaa216c178bbcd2bc5f3963c133ba98bcd509431" => :el_capitan
  end

  # Fix incorrect encoding of headers
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=870741
  # https://bugzilla.gnome.org/show_bug.cgi?id=788283
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/bf4e8e3395/libgda/encoding.patch"
    sha256 "db6c7f10a9ed832585aae65eb135b718a69c5151375aa21e475ba3031beb0068"
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "readline"
  depends_on "libgcrypt"
  depends_on "sqlite"
  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-binreloc",
                          "--disable-gtk-doc",
                          "--without-java"
    system "make"
    system "make", "install"
  end
end
