class Dbus < Formula
  # releases: even (1.10.x) = stable, odd (1.11.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.12.4.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dbus/dbus_1.12.4.orig.tar.gz"
  sha256 "f9756b68ec68065ae2dafcf1191ee40b4cb06e9534a01f6a74d5a4d7894221c7"

  bottle do
    rebuild 1
    sha256 "9aee7bafaa5349e1f8dd6a2051520df139b571644e2b63fe101785a1205bc777" => :high_sierra
    sha256 "cdbb9a8a5934bbd380bdae582bc9804b3f874a1e96f658b9e075c96827186d74" => :sierra
    sha256 "8eede738702aef04bc8b48c7b18ef79486ef4921e8e8b3950490dbdb51aa5189" => :el_capitan
  end

  devel do
    url "https://dbus.freedesktop.org/releases/dbus/dbus-1.13.2.tar.gz"
    sha256 "945deb349a7e2999184827c17351c1bf93c6395b9c3ade0c91cad42cb93435b1"
  end

  head do
    url "https://anongit.freedesktop.org/git/dbus/dbus.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "xmlto" => :build

  # Patch applies the config templating fixed in https://bugs.freedesktop.org/show_bug.cgi?id=94494
  # Homebrew pr/issue: 50219
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0a8a55872e/d-bus/org.freedesktop.dbus-session.plist.osx.diff"
    sha256 "a8aa6fe3f2d8f873ad3f683013491f5362d551bf5d4c3b469f1efbc5459a20dc"
  end

  def install
    # Fix the TMPDIR to one D-Bus doesn't reject due to odd symbols
    ENV["TMPDIR"] = "/tmp"

    # macOS doesn't include a pkg-config file for expat
    ENV["EXPAT_CFLAGS"] = "-I#{MacOS.sdk_path}/usr/include"
    ENV["EXPAT_LIBS"] = "-lexpat"

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./autogen.sh", "--no-configure" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--enable-xml-docs",
                          "--disable-doxygen-docs",
                          "--enable-launchd",
                          "--with-launchd-agent-dir=#{prefix}",
                          "--without-x",
                          "--disable-tests"
    system "make", "install"
  end

  def post_install
    # Generate D-Bus's UUID for this machine
    system "#{bin}/dbus-uuidgen", "--ensure=#{var}/lib/dbus/machine-id"
  end

  test do
    system "#{bin}/dbus-daemon", "--version"
  end
end
