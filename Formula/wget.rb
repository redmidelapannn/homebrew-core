class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.19.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/wget/wget-1.19.5.tar.gz"
  sha256 "b39212abe1a73f2b28f4c6cb223c738559caac91d6e416a6d91d4b9d55c9faee"

  bottle do
    rebuild 1
    sha256 "296f70c65df474a4ca1e644105c352bf952c92bfe911ecebb936bdeca057cc65" => :mojave
    sha256 "5898f4873cb8e12876f50d3186f893416630ebc843a9baa7516e5440840ff9ac" => :high_sierra
    sha256 "dac1a54f5519b0f332a2a9aee749d0eddb469703b78bf35d2a799f162ab2aebd" => :sierra
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
  depends_on "gpgme" => :optional
  depends_on "libmetalink" => :optional
  depends_on "pcre" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-ssl=openssl
      --with-libssl-prefix=#{Formula["openssl"].opt_prefix}
      --disable-debug
    ]

    args << "--disable-pcre" if build.without? "pcre"
    args << "--with-metalink" if build.with? "libmetalink"
    args << "--with-gpgme-prefix=#{Formula["gpgme"].opt_prefix}" if build.with? "gpgme"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"
  end
end
