class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.15/gphoto2-2.5.15.tar.bz2"
  sha256 "ae571a227983dc9997876702a73af5431d41f287ea0f483cda897c57a6084a77"

  bottle do
    cellar :any
    rebuild 1
    sha256 "18d544edabc9ead0fb6fe0151e5ae047fdcaa1f7f8c11d0f41dda0968cb9dd78" => :high_sierra
    sha256 "d7e0ebca7d7d1fbb1f2258a73bf7c88b03df7e02e37bb5b52454b6296791d86c" => :sierra
    sha256 "473c28b8d3ce0ca4d6bfc35b1a9df34cdfcb99e2af2378aa9e95ae656fe41fea" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libgphoto2"
  depends_on "popt"
  depends_on "readline"

  depends_on "libexif" => :optional
  depends_on "aalib" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gphoto2 -v")
  end
end
