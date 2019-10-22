class Libnids < Formula
  desc "Implements E-component of network intrusion detection system"
  homepage "https://libnids.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libnids/libnids/1.24/libnids-1.24.tar.gz"
  sha256 "314b4793e0902fbf1fdb7fb659af37a3c1306ed1aad5d1c84de6c931b351d359"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "a854b1a7693c6a480023a016d4c8e7508dd591d804aa2175d6ba426eb21f5f45" => :catalina
    sha256 "537bf37c7f8b25592da7ad9aeb395db9c271dab32d73f124d0c06d9dcd8af23f" => :mojave
    sha256 "e8b5f6ed57e861e31fa98b5db11e9b160f2d1c40baa1c4a863c452ad7d6212cf" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libnet"

  # Patch fixes -soname and .so shared library issues. Unreported.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/libnids/1.24.patch"
    sha256 "d9339c16f89915a02025f10f26aab5bb77c2af85926d2d9ff52e9c7bf2092215"
  end

  def install
    # autoreconf the old 2005 era code for sanity.
    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}",
                          "--enable-shared"
    system "make", "install"
  end
end
