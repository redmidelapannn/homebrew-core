# NOTE: Configure will fail if using awk 20110810 from dupes.
# Upstream issue: https://savannah.gnu.org/bugs/index.php?37063
class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "http://ftpmirror.gnu.org/wget/wget-1.17.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/wget/wget-1.17.1.tar.xz"
  sha256 "fe559b61eb9cc01635ac6206a14e02cb51591838c35fa83c7a4aacae0bdd97c9"
  revision 1

  bottle do
    sha256 "1a7f3deba119af9ab75c2f9b7600c39a0930b2236058f140d814b3dedeb02b47" => :el_capitan
    sha256 "19a1cbfab687ae454bd4b589285c9fb9fb763c38350e5025350a562eb024c18a" => :yosemite
    sha256 "518efd634284b73ef67940667793b9a96c2c94a10e45acdd039c21dcbc99fae7" => :mavericks
  end

  head do
    url "git://git.savannah.gnu.org/wget.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  deprecated_option "enable-iri" => "with-iri"
  deprecated_option "enable-debug" => "with-debug"

  option "with-iri", "Enable iri support"
  option "with-debug", "Build with debug support"

  depends_on "pkg-config" => :build
  depends_on "pod2man" => :build if MacOS.version <= :snow_leopard
  depends_on "openssl" => :recommended
  depends_on "libressl" => :optional
  depends_on "libidn" if build.with? "iri"
  depends_on "pcre" => :optional
  depends_on "libmetalink" => :optional
  depends_on "gpgme" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-ssl=openssl
    ]

    if build.with? "libressl"
      args << "--with-libssl-prefix=#{Formula["libressl"].opt_prefix}"
    else
      args << "--with-libssl-prefix=#{Formula["openssl"].opt_prefix}"
    end

    args << "--disable-debug" if build.without? "debug"
    args << "--disable-iri" if build.without? "iri"
    args << "--disable-pcre" if build.without? "pcre"
    args << "--with-metalink" if build.with? "libmetalink"
    args << "--with-gpgme-prefix=#{Formula["gpgme"].opt_prefix}" if build.with? "gpgme"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "-", "https://google.com"
  end
end
