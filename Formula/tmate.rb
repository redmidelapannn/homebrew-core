class Tmate < Formula
  desc "Instant terminal sharing"
  homepage "https://tmate.io/"
  url "https://github.com/tmate-io/tmate/archive/2.2.1.tar.gz"
  sha256 "d9c2ac59f42e65aac5f500f0548ea8056fd79c9c5285e5af324d833e2a84c305"
  revision 1

  head "https://github.com/tmate-io/tmate.git"

  bottle do
    cellar :any
    revision 1
    sha256 "5053c0638645deb9eddfe43d3cae3a60a51c2d8fa2a03a8648a1b979ef45da38" => :el_capitan
    sha256 "4817ca9f6ef770a53d05f815073b4dd68b767520ad2ac06ce59c6ea6414e444f" => :yosemite
    sha256 "65e9239a142d18e9485e5a941c583cae30f0c708489bebafe0662e5f888c792d" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libevent"
  depends_on "libssh"
  depends_on "msgpack"

  def install
    system "sh", "autogen.sh"

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/tmate", "-V"
  end
end
