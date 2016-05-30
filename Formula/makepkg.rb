class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "https://projects.archlinux.org/git/pacman.git",
      :tag => "v5.0.1",
      :revision => "f38de43eb68f1d9c577b4378310640c1eaa93338"

  head "https://projects.archlinux.org/git/pacman.git"

  bottle do
    sha256 "156dc892331260268043bb3d1555e972b970e9e71c68eb1b9f36c40b6d6f03f0" => :el_capitan
    sha256 "70287b85e2cdc03cbcb5ea573bc549f571c4fd1f4dd3357ce4952f4ed15acd6c" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "asciidoc" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "bash"
  depends_on "fakeroot"
  depends_on "gettext"
  depends_on "libarchive"
  depends_on "openssl"
  depends_on "gpgme" => :optional

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"

    system "make", "install"
  end

  test do
    (testpath/"PKGBUILD").write <<-EOS.undent
      source=(https://androidnetworktester.googlecode.com/files/10kb.txt)
      pkgver=2.1
      pkgrel=1
    EOS
    system "#{bin}/makepkg", "-dg"
  end
end
