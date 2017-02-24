class Gmime < Formula
  desc "MIME mail utilities"
  homepage "https://spruce.sourceforge.io/gmime/"
  url "https://download.gnome.org/sources/gmime/2.6/gmime-2.6.23.tar.xz"
  sha256 "7149686a71ca42a1390869b6074815106b061aaeaaa8f2ef8c12c191d9a79f6a"

  bottle do
    rebuild 1
    sha256 "751d72d7b45f9d2d8df002cbb117cdca224123b5ec47ab5bdefbce7001f68a9d" => :sierra
    sha256 "72a7d8dd62939262395f07a2559414d6b6a49b03941218bd4608e94f49b3817d" => :el_capitan
    sha256 "3ec9428390211b669a01c43261904222db705dd0328df232f7e84fdccfae97a3" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libgpg-error" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-largefile",
                          "--enable-introspection",
                          "--disable-vala",
                          "--disable-mono",
                          "--disable-glibtest"
    system "make", "install"
  end
end
