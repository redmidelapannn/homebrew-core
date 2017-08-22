class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.0.3.tar.lz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.0.3.tar.lz"
  sha256 "b52fd3bc9693de16db93aa23a11a56f3cdb3fbf005a360145401ab5d252490f5"

  bottle do
    cellar :any
    sha256 "6e28310bdf26536e6b9a7ba3017406233c2c93ede857b95511d407e20dd6ae9b" => :sierra
    sha256 "d7f09eca2103569f8865a8a0f2abeb0960ec3f4908ecc996942da4638bd2dc03" => :el_capitan
    sha256 "5f6f4e744ee0827595e04c80f2061b7c5c5ce72f7c62f7f182b4c1e24cd5a6af" => :yosemite
  end

  head do
    url "https://gitlab.com/libidn/libidn2.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "gettext" => :build
    depends_on "gengetopt" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libunistring"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-doc"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system bin/"idn2", "räksmörgås.se", "blåbærgrød.no"
  end
end
