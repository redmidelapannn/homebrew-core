class Spdylay < Formula
  desc "Experimental implementation of SPDY protocol versions 2, 3, and 3.1"
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.4.0.tar.gz"
  sha256 "31ed26253943b9d898b936945a1c68c48c3e0974b146cef7382320a97d8f0fa0"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "1a41b61a3b4f5ce6413f73afc57a8d98e1dd20686cf96208c27f18f21a5a5ddf" => :mojave
    sha256 "0c0cc862a7bdd4ce341d8746fa0dd63edadc2a616c932fedcd99b37e86578cfc" => :high_sierra
    sha256 "32489916bc2bc1b8e7f3e735e75ae6514c5b27976fe1090a837b0a15adec1011" => :sierra
    sha256 "fa174c4382ed8de55cdf026f714d3131c94571e7fb3e0837a33137ad9c3aa9d3" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libxml2" if MacOS.version <= :lion
  depends_on "openssl"

  def install
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      ENV["ac_cv_search_clock_gettime"] = "no"
    end

    if MacOS.version > :lion
      Formula["libxml2"].stable.stage { (buildpath/"m4").install "libxml.m4" }
    end

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Check here for popular websites using SPDY:
    # https://w3techs.com/technologies/details/ce-spdy/all/all
    system "#{bin}/spdycat", "-ns", "https://www.twitter.com/"
  end
end
