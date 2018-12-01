class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.20.tar.gz"
  mirror "https://ftpmirror.gnu.org/wget/wget-1.20.tar.gz"
  sha256 "8a057925c74c059d9e37de63a63b450da66c5c1c8cef869a6df420b3bb45a0cf"

  bottle do
    rebuild 1
    sha256 "e1380cef7cbf6b95705241f288037cff3b06e719e66d4bb9030bc03f83d38b02" => :mojave
    sha256 "5bcf34ea928d078d9721f000ef52f5c705da7d39c73372374d3f614bf5f06051" => :high_sierra
    sha256 "bb702c6163adf116baf2e650a19cbdd7af88866b4e62a84511d0705de6091ba7" => :sierra
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
    system "./bootstrap", "--skip-po" if build.head?
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
