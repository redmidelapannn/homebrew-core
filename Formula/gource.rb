class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.44/gource-0.44.tar.gz"
  sha256 "2604ca4442305ffdc5bb1a7bac07e223d59c846f93567be067e8dfe2f42f097c"
  revision 1

  bottle do
    sha256 "e018e46e02dc1c2359bdff1b7150672e6da08aed0349e4d21d24cd782a4ad394" => :sierra
    sha256 "3885ca121c3f6bd2e123df86c3fc9c0e2bb599f3ea3aeb3a950fbaf0f342cec8" => :el_capitan
    sha256 "7ff080ad1e4634466f046e97b04f0aa8337765440bcc0ac6bded1bb129cf24a6" => :yosemite
  end

  head do
    url "https://github.com/acaudwell/Gource.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :x11 => :optional

  depends_on "pkg-config" => :build
  depends_on "glm" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "pcre"
  depends_on "sdl2"
  depends_on "sdl2_image"

  # boost failing on lion
  depends_on :macos => :mountain_lion

  if MacOS.version < :mavericks
    depends_on "boost@1.61" => "c++11"
  else
    depends_on "boost@1.61"
  end

  needs :cxx11

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    system "autoreconf", "-f", "-i" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--without-x"
    system "make", "install"
  end

  test do
    system "#{bin}/gource", "--help"
  end
end
