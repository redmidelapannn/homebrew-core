class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdread/6.0.0/libdvdread-6.0.0.tar.bz2"
  sha256 "b33b1953b4860545b75f6efc06e01d9849e2ea4f797652263b0b4af6dd10f935"

  bottle do
    cellar :any
    rebuild 1
    sha256 "45918c9c0009a8791393799a77723f14116431aaec4c6c05d795a612fea7c835" => :high_sierra
    sha256 "204b68611a1c020bd00019d5b762ffd6e5b3966e95b70aba202f9051fd3dd0be" => :sierra
    sha256 "859a26b13cd7a9eacac640dbe8e356c84c06c659f86f509e3f3816fc55df3f78" => :el_capitan
  end

  head do
    url "https://git.videolan.org/git/libdvdread.git"
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
