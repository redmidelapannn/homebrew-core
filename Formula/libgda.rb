class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "http://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/5.2/libgda-5.2.8.tar.xz"
  sha256 "e2876d987c00783ac3c1358e9da52794ac26f557e262194fcba60ac88bafa445"
  revision 2

  bottle do
    sha256 "df387af481a7b0fa56935ab5aa257e9efc4c657905c0a26819e70a0a6f524695" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgcrypt"
  depends_on "libgee"
  depends_on "openssl"
  depends_on "readline"

  # this build uses the sqlite source code that comes with libgda,
  # as opposed to using the system or brewed sqlite3, which is not supported on macOS,
  # as mentioned in https://github.com/GNOME/libgda/blob/95eeca4b0470f347c645a27f714c62aa6e59f820/libgda/sqlite/README#L31
  # The following patch ensures that libgda's sqlite3.h header will get used instead of the system one.
  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/8c93c519f7b234af318cc21e93a1b8164622e530/databases/libgda5/files/patch-use-embedded-sqlite3.diff?full_index=1"
    sha256 "140742f6214f6f6ea495a9854eef99fa06141157a15556ebdf7be55794267a0f"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-binreloc",
                          "--disable-gtk-doc",
                          "--without-java",
                          "--enable-introspection",
                          "--enable-system-sqlite=no"
    system "make"
    system "make", "install"
  end
end
