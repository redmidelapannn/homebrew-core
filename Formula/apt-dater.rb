class AptDater < Formula
  desc "Manage package updates on remote hosts using SSH"
  homepage "https://www.ibh.de/apt-dater/"
  url "https://github.com/DE-IBH/apt-dater.git",
      :tag => "v1.0.3",
      :revision => "fdad3b43e50bc3582e391d6feabae150e133b3b3"

  head "https://github.com/DE-IBH/apt-dater.git"

  bottle do
    sha256 "e115b2af949d968d2d5312d61cacee41b5438d53f586bb8aae0d067f42baf44e" => :sierra
    sha256 "6861b6668dda1b2e53dc8e4efc6f293f4d24c6a89b7c3d522141a7ae256fbbfa" => :el_capitan
    sha256 "4898c1e5acd0ef45a9ca969fcc490212e8b582a179ecf7b767375015ee9de138" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "popt"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "AM_LDFLAGS=", "install"
  end

  test do
    system "#{bin}/apt-dater", "-v"
  end
end
