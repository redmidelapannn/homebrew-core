class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.12.6.tar.gz"
  sha256 "a03b6fe430d2d83b916975aa525178893156cb1fa478e86160acc2088a35d036"

  bottle do
    cellar :any
    rebuild 1
    sha256 "11c6ea89e2a2898bf78b5d1ce6d9a8218fca148aec6572158174657a1115b06d" => :sierra
    sha256 "f3b2e4efdb2bdc92515e99aba5275f656becd9af2b64d7a862394f0ece6edf81" => :el_capitan
    sha256 "9762533303b3321c3826cd1ab2f0ba1df0cf1107b7954a7d3f829bf0d7ae5821" => :yosemite
  end

  head do
    url "https://github.com/indexdata/pazpar2.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended
  depends_on "yaz"

  def install
    system "./buildconf.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/pazpar2", "-V"
  end
end
