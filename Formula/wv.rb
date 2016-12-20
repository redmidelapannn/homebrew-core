class Wv < Formula
  desc "Programs for accessing Microsoft Word documents"
  homepage "http://wvware.sourceforge.net/"
  url "http://abisource.com/downloads/wv/1.2.9/wv-1.2.9.tar.gz"
  sha256 "4c730d3b325c0785450dd3a043eeb53e1518598c4f41f155558385dd2635c19d"

  bottle do
    rebuild 1
    sha256 "bcf90a5a798fed1efff1065f9db0217fde3cd0ffd722522114833fe4e35f75ca" => :sierra
    sha256 "fa5ec539919dd5d7e3d9cad12535aa059ffe2d0dab94211748a52e837ca0eb61" => :el_capitan
    sha256 "3557604cc4dbc82b29ef7a9bcbeec245bbc1cc37524293519d70825a2f891292" => :yosemite
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
