class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod/pianod-175.tar.gz"
  sha256 "19733d4937b48707eebcde75775d865d6bf925efa86d8989f0efb2392ab4cdf9"
  revision 1

  bottle do
    sha256 "8821425f57713d97b45684bf11dfc2ee0303e5dedad7ec09a1f3b22abd0a082b" => :high_sierra
    sha256 "012a8e7275fd6d61a08d82c5319ebe524e521c6de9de9c8ab26397696ad06f7f" => :sierra
    sha256 "e81c4020be81255a08021b8b160f3944d04fe3bd4b74482b72922361388f15e4" => :el_capitan
  end

  depends_on "pkg-config" => :build

  depends_on "libao"
  depends_on "libgcrypt"
  depends_on "gnutls"
  depends_on "json-c"
  depends_on "faad2" => :recommended
  depends_on "mad" => :recommended

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pianod", "-v"
  end
end
