class Ykneomgr < Formula
  desc "CLI and C library to interact with the CCID-part of the YubiKey NEO"
  homepage "https://developers.yubico.com/libykneomgr/"
  url "https://developers.yubico.com/libykneomgr/Releases/libykneomgr-0.1.8.tar.gz"
  sha256 "2749ef299a1772818e63c0ff5276f18f1694f9de2137176a087902403e5df889"

  bottle do
    cellar :any
    rebuild 1
    sha256 "28bf2646e554932de6f9505c0976d8c7cda54abc81826906615b859c8c6b09d5" => :sierra
    sha256 "10f805115d25c87899fa9c4547ae4a7a71ff2edd99227ea6a0ed206d1c8dcbdf" => :el_capitan
    sha256 "e09a95fb648afce24bcf48e2a2667e85a0a81815f7db964f03038796f06a23f2" => :yosemite
  end

  head do
    url "https://github.com/Yubico/libykneomgr.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gengetopt" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "libzip"

  def install
    system "make", "autoreconf" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match "0.1.8", shell_output("#{bin}/ykneomgr --version")
  end
end
