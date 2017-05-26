class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.19.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/wget/wget-1.19.1.tar.gz"
  sha256 "9e4f12da38cc6167d0752d934abe27c7b1599a9af294e73829be7ac7b5b4da40"

  bottle do
    rebuild 1
    sha256 "f52906cfe5b9ab25e4af2708c30a75f3cc96e81b709b4023191adc2e64d7151e" => :sierra
    sha256 "49ab50dc08ddbff4828c31ba6ddb893c1ffdd85c2d75b601cf0662fc376c8824" => :el_capitan
    sha256 "818cfb1c55da86c4333ec6fca89a5b0d8d6eae77abcc38033a646fcb9e4aa7f0" => :yosemite
  end

  head do
    url "https://git.savannah.gnu.org/git/wget.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  deprecated_option "enable-debug" => "with-debug"
  deprecated_option "enable-iri" => "with-iri"
  deprecated_option "with-iri" => "with-libidn2"

  option "with-debug", "Build with debug support"
  option "with-libidn2", "Build with support for Internationalized Domain Names"

  depends_on "pkg-config" => :build
  depends_on "pod2man" => :build if MacOS.version <= :snow_leopard
  depends_on "openssl"
  depends_on "pcre" => :optional
  depends_on "libmetalink" => :optional
  depends_on "gpgme" => :optional
  depends_on "libunistring" if build.with? "libidn2"

  resource "libidn2" do
    url "https://ftp.gnu.org/gnu/libidn/libidn2-2.0.2.tar.gz"
    mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.0.2.tar.gz"
    sha256 "8cd62828b2ab0171e0f35a302f3ad60c3a3fffb45733318b3a8205f9d187eeab"
  end

  def install
    # Fixes undefined symbols _iconv, _iconv_close, _iconv_open
    # Reported 10 Jun 2016: https://savannah.gnu.org/bugs/index.php?48193
    ENV.append "LDFLAGS", "-liconv"

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-ssl=openssl
      --with-libssl-prefix=#{Formula["openssl"].opt_prefix}
    ]

    args << "--disable-debug" if build.without? "debug"
    args << "--disable-pcre" if build.without? "pcre"
    args << "--with-metalink" if build.with? "libmetalink"
    args << "--with-gpgme-prefix=#{Formula["gpgme"].opt_prefix}" if build.with? "gpgme"

    if build.with? "libidn2"
      resource("libidn2").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--disable-silent-rules",
                              "--prefix=#{libexec}/vendor/libidn2",
                              "--with-packager=Homebrew"
        system "make", "install"
      end
      ENV.prepend "LDFLAGS", "-L#{libexec}/vendor/libidn2/lib"
      ENV.prepend "CPPFLAGS", "-I#{libexec}/vendor/libidn2/include"
      args << "--enable-iri"
    else
      args << "--disable-iri"
    end

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"

    if build.with? "libidn2"
      system bin/"wget", "--local-encoding=utf-8", "www.räksmörgås.se"
      assert_predicate testpath/"index.html", :exist?,
                       "Failed to download IDN example site!"
      assert_match "www.xn--rksmrgs-5wao1o.se", File.read("index.html")
    end
  end
end
