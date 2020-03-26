class Spdylay < Formula
  desc "Experimental implementation of SPDY protocol versions 2, 3, and 3.1"
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.4.0.tar.gz"
  sha256 "31ed26253943b9d898b936945a1c68c48c3e0974b146cef7382320a97d8f0fa0"
  revision 3

  bottle do
    cellar :any
    rebuild 1
    sha256 "13f88f6cf0de479d990a8caa0ed14fe9081235c360f0ed2327b69bc671b7c186" => :catalina
    sha256 "51987d5927347f6783f8d69358cb8525d212a4bcb69b221ef3855d648ff73fbf" => :mojave
    sha256 "765162da6eb77bed205e73d002b9598c5804475fa879e65d947f97641a4d20a7" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    ENV["ac_cv_search_clock_gettime"] = "no" if MacOS.version == "10.11" && MacOS::Xcode.version >= "8.0"

    Formula["libxml2"].stable.stage { (buildpath/"m4").install "libxml.m4" }

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Check here for popular websites using SPDY:
    # https://w3techs.com/technologies/details/ce-spdy/all/all
    system "#{bin}/spdycat", "-ns", "https://www.academia.edu/"
  end
end
