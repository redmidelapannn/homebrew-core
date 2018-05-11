
class LibcdioParanoia < Formula
  desc "Audio CD ripper based on libcdio"
  homepage "https://www.gnu.org/software/libcdio/"
  url "https://ftp.gnu.org/gnu/libcdio/libcdio-paranoia-10.2+0.94+2.tar.gz"
  mirror "https://ftpmirror.gnu.org/libcdio/libcdio-paranoia-10.2+0.94+2.tar.gz"
  version "10.2+0.94+2"
  sha256 "d60f82ece97eeb92407a9ee03f3499c8983206672c28ae5e4e22179063c81941"

  bottle do
    cellar :any
    sha256 "75e8d985622e89f9ab770cbb0b83858b10861fbc9013670a35059c64378390af" => :high_sierra
    sha256 "2141a0c34c5ae27159d7f070ee8c8fa54d98e1d4ba163211fe5dd0de26796a29" => :sierra
    sha256 "945356fecca26f9e16bf59a44aac79ac1dc4b03da2054a1e652cd51080e46865" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libcdio"

  def install
    system "./configure", "--without-versioned-libs",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /cdparanoia/, shell_output("#{bin}/cd-paranoia -V 2>&1", 0).partition(" ").first
    shell_output("#{bin}/cd-paranoia -V 2>&1", 0)
  end
end
