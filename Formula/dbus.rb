class Dbus < Formula
  # releases: even (1.10.x) = stable, odd (1.11.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.12.8.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dbus/dbus_1.12.8.orig.tar.gz"
  sha256 "e2dc99e7338303393b6663a98320aba6a63421bcdaaf571c8022f815e5896eb3"
  revision 1

  bottle do
    sha256 "f0aeadc358b27f27a27b96b1d5a6c843aded8c1e2204e35cd2f411677a536140" => :high_sierra
    sha256 "261b1a025c991286d58e7a59ebfe803cb727e7edfbb3f9f37616c6f2e1ba53f0" => :sierra
    sha256 "6acd8d545af4b6ac64e25f3aa1b676cddeb2039c11d43f1042fde029ce50bae9" => :el_capitan
  end

  devel do
    url "https://dbus.freedesktop.org/releases/dbus/dbus-1.13.4.tar.gz"
    sha256 "8a8f0b986ac6214da9707da521bea9f49f09610083c71fdc8eddf8b4c54f384b"
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

  # add macports patch to disable external authentication
  # reported upstream at https://bugs.freedesktop.org/show_bug.cgi?id=106545
  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/ac715bd0270b712f3d6c0432b8028f5bc0b042c3/devel/dbus/files/patch-configure.diff"
    sha256 "31dd78cc2398ccab54b6353009db9c370a496b1c0e4a0ac33ecef745664a186f"
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
