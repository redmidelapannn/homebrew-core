class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdread/6.1.1/libdvdread-6.1.1.tar.bz2"
  sha256 "3e357309a17c5be3731385b9eabda6b7e3fa010f46022a06f104553bf8e21796"

  bottle do
    cellar :any
    sha256 "787938a70bdb675a9af47add5fb666b06ace89f46a6b3326cc5894e0d16e4188" => :catalina
    sha256 "9a8e795627c887c160381605ced82afa4823e1f7b332262ace39df40704c9f88" => :mojave
    sha256 "8045bd64d158d51ebbd5d78389512042281d525d98aef0efbd46b5576026f240" => :high_sierra
  end

  head do
    url "https://code.videolan.org/videolan/libdvdread.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libdvdcss"

  def install
    ENV.append "CFLAGS", "-DHAVE_DVDCSS_DVDCSS_H"
    ENV.append "LDFLAGS", "-ldvdcss"

    system "autoreconf", "-if" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
