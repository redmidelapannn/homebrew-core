class Libdvdnav < Formula
  desc "DVD navigation library"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdnav/6.0.0/libdvdnav-6.0.0.tar.bz2"
  sha256 "f0a2711b08a021759792f8eb14bb82ff8a3c929bf88c33b64ffcddaa27935618"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9b490c47628253819b2cf6748f09bc01293dc5b42bd56402f2e711bac1166453" => :high_sierra
    sha256 "3ca32275a9da9d2079c3a4c2c435363965daaa9ade3cc924d8da898e8081da2a" => :sierra
    sha256 "7350e16bbd8b757bf278e0b2fd73515cefd6dfa807acdfbe5194504d157608c6" => :el_capitan
  end

  head do
    url "https://git.videolan.org/git/libdvdnav.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libdvdread"

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
