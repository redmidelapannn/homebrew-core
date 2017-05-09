class Djview4 < Formula
  desc "Viewer for the DjVu image format"
  homepage "https://djvu.sourceforge.io/djview4.html"
  url "https://downloads.sourceforge.net/project/djvu/DjView/4.10/djview-4.10.6.tar.gz"
  sha256 "8446f3cd692238421a342f12baa365528445637bffb96899f319fe762fda7c21"
  revision 1

  bottle do
    rebuild 1
    sha256 "8f3077a5842a7ff2323f4da3edb7cc8cdaf1db5afe2c7c40038783fad77bd526" => :sierra
    sha256 "11c155e2de048162c326270687a0f770fbd6fd2a1cb35cc0041bdcc84fde9864" => :el_capitan
    sha256 "1f89cc55d3324ec1ff0e9ceaa7c9d3db5438c37e882b4e86646c449519539fcf" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "djvulibre"
  # avoid bug QTBUG-58344 on qt 5.7 and 5.8. version 5.9 would be fine
  depends_on "qt@5.5"

  def install
    inreplace "src/djview.pro", "10.6", MacOS.version
    system "autoreconf", "-fiv"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-x=no",
                          "--disable-nsdejavu",
                          "--disable-desktopfiles"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"

    # From the djview4.8 README:
    # Note3: Do not use command "make install".
    # Simply copy the application bundle where you want it.
    prefix.install "src/djview.app"
  end
end
