class Wv < Formula
  desc "Programs for accessing Microsoft Word documents"
  homepage "https://wvware.sourceforge.io/"
  url "https://abisource.com/downloads/wv/1.2.9/wv-1.2.9.tar.gz"
  sha256 "4c730d3b325c0785450dd3a043eeb53e1518598c4f41f155558385dd2635c19d"

  bottle do
    rebuild 1
    sha256 "29b22b88d6e8ec81d7d56d6c1d25358635de182d39a41d1175c7b0e76ea32082" => :sierra
    sha256 "0595f0163eb202ddc4c808ba930aa5945d26cf0267e6f70e5d95f833857ec551" => :el_capitan
    sha256 "c0fa62a7edcb70edadef15c8aedebf0aed4e679bea8ad4f13133da7e95df873a" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libgsf"
  depends_on "libwmf"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    ENV.deparallelize
    # the makefile generated does not create the file structure when installing
    # till it is fixed upstream, create the target directories here.
    # http://www.abisource.com/mailinglists/abiword-dev/2011/Jun/0108.html

    bin.mkpath
    (lib/"pkgconfig").mkpath
    (include/"wv").mkpath
    man1.mkpath
    (share/"wv/wingdingfont").mkpath
    (share/"wv/patterns").mkpath

    system "make", "install"
  end
end
