class Gdnsd < Formula
  desc "Authoritative-only DNS server"
  homepage "https://gdnsd.org/"
  url "https://github.com/gdnsd/gdnsd/releases/download/v2.4.0/gdnsd-2.4.0.tar.xz"
  sha256 "3d56ccbb27054dc155839d94df136d760ac361abe868aa6a8c3dbfc9e464bb99"

  bottle do
    rebuild 1
    sha256 "38e196d73e78db185e5c8e50d192888cff29703b915566f43b5e820574fe85ca" => :mojave
    sha256 "360923c7a8a94864ea83cfc61c8af02f914640da6bebdfe7cd9954ff625d63af" => :high_sierra
    sha256 "eed69a6bcb60c58176a96490c6b3a25d255b9dd8888e92f224ad5f1bf07c281b" => :sierra
    sha256 "0c1eb83c2af469cebc8acb01b17ee4a2c537bcdf60516a4b92bcee8ed535e2e4" => :el_capitan
  end

  head do
    url "https://github.com/gdnsd/gdnsd.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libev"
  depends_on "libunwind-headers"
  depends_on "ragel"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-rundir=#{var}/run",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--without-urcu"
    system "make", "install"
  end

  test do
    (testpath/"config").write("options => { listen => [ 127.0.0.1 ] }")
    system "#{sbin}/gdnsd", "-c", testpath, "checkconf"
  end
end
