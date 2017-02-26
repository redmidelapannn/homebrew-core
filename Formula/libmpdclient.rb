class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.10.tar.gz"
  sha256 "bf88ddd9beceadef11144811adaabe45008005af02373595daa03446e6b1bf3d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c24997e921a8ff77322c59546ee64a6dad79a943cf80a9d77d9b97cdf18907da" => :sierra
    sha256 "10dcc7880fb92441b82def5f9c08eca41c5094a26c0e4a481c7ffc3500379e5d" => :el_capitan
    sha256 "0ede4644756081f2b39c639dd8cc257901cde3534ca4818898a26476a82f7eb1" => :yosemite
  end

  head do
    url "git://git.musicpd.org/master/libmpdclient.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "doxygen" => :build

  def install
    inreplace "autogen.sh", "libtoolize", "glibtoolize"
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
