class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.19.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/wget/wget-1.19.5.tar.gz"
  sha256 "b39212abe1a73f2b28f4c6cb223c738559caac91d6e416a6d91d4b9d55c9faee"

  bottle do
    rebuild 1
    sha256 "dc53a14912847f49fbb188cb9fdeb3eb034ec6e50d29c0a8c20eb734d94f7a84" => :mojave
    sha256 "db6f2038b5d52db49a2dd0d76c99cc8633edb1f16986d44031b66b390c670ab4" => :high_sierra
    sha256 "70af10d2d5c96a94b921157486626ffb2898d24d6bf94bfae513a05827320ad5" => :sierra
  end

  head do
    url "https://git.savannah.gnu.org/git/wget.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  depends_on "pkg-config" => :build
  depends_on "pod2man" => :build if MacOS.version <= :snow_leopard
  depends_on "libidn2"
  depends_on "openssl"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-ssl=openssl",
                          "--with-libssl-prefix=#{Formula["openssl"].opt_prefix}",
                          "--disable-debug"
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"
  end
end
