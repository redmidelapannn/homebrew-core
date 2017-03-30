class Spdylay < Formula
  desc "Experimental implementation of SPDY protocol versions 2, 3, and 3.1"
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.4.0.tar.gz"
  sha256 "31ed26253943b9d898b936945a1c68c48c3e0974b146cef7382320a97d8f0fa0"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "00951c2ed28e314ba8813d9ca61ee4aea55f83f8dd29b52d6af87397ebe724af" => :el_capitan
    sha256 "e4b63d897281831ffc98821e285c10890e9b3126c8631ee07095daca714fdaf3" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent" => :recommended
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
    system "#{bin}/spdycat", "-ns", "https://cloudflare.com/"
  end
end
