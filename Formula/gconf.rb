class Gconf < Formula
  desc "System for storing user application preferences"
  homepage "https://projects.gnome.org/gconf/"
  url "https://download.gnome.org/sources/GConf/3.2/GConf-3.2.6.tar.xz"
  sha256 "1912b91803ab09a5eed34d364bf09fe3a2a9c96751fde03a4e0cfa51a04d784c"
  revision 1

  bottle do
    rebuild 1
    sha256 "a521cdd9c1f5971944da71c50e50cc48db36c208fabfe89630d7756fdec1a67f" => :mojave
    sha256 "729901d616932274bae9be777039e016c44566ccca1ad2904b79ebb92a016e6e" => :high_sierra
    sha256 "b370575df1bc3e49fee8e5f0a0758ddc137a1f89698f8b2e1c7f35e113e6d463" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "dbus"
  depends_on "dbus-glib"
  depends_on "gettext"
  depends_on "glib"
  depends_on "orbit"
  uses_from_macos "libxml2"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-silent-rules", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"

    # Refresh the cache post-install, not during install.
    rm lib/"gio/modules/giomodule.cache"
  end

  def post_install
    system Formula["glib"].opt_bin/"gio-querymodules", HOMEBREW_PREFIX/"lib/gio/modules"
  end
end
