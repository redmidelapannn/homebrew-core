class Dbus < Formula
  # releases: even (1.10.x) = stable, odd (1.11.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.10.8.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dbus/dbus_1.10.8.orig.tar.gz"
  sha256 "baf3d22baa26d3bdd9edc587736cd5562196ce67996d65b82103bedbe1f0c014"
  head "https://anongit.freedesktop.org/git/dbus/dbus.git"

  bottle do
    revision 1
    sha256 "232bb98b3d9fcce88e76d898832c60c32bf1036bd4d62461a2ccaa654b76661f" => :el_capitan
    sha256 "0e99f8bedf96dd0d16616eb52e4b8f0d8049f6630427f8b24596d29fcd9f6cd2" => :yosemite
    sha256 "a33aadba583458fde7ef0f0525e179edb8b9b61fa3094534f56e2f5fd9df1b50" => :mavericks
  end

  devel do
    url "https://dbus.freedesktop.org/releases/dbus/dbus-1.11.4.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dbus/dbus_1.11.4.orig.tar.gz"
    sha256 "474de2afde8087adbd26b3fc5cbf6ec45559763c75b21981169a9a1fbac256c9"
  end

  # Patch applies the config templating fixed in https://bugs.freedesktop.org/show_bug.cgi?id=94494
  # Homebrew pr/issue: 50219
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0a8a55872e/d-bus/org.freedesktop.dbus-session.plist.osx.diff"
    sha256 "a8aa6fe3f2d8f873ad3f683013491f5362d551bf5d4c3b469f1efbc5459a20dc"
  end

  def install
    # Fix the TMPDIR to one D-Bus doesn't reject due to odd symbols
    ENV["TMPDIR"] = "/tmp"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--disable-xml-docs",
                          "--disable-doxygen-docs",
                          "--enable-launchd",
                          "--with-launchd-agent-dir=#{prefix}",
                          "--without-x",
                          "--disable-tests"
    system "make"
    ENV.deparallelize
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
