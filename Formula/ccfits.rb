class Ccfits < Formula
  homepage "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/"
  url "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/CCfits-2.5.tar.gz"
  sha256 "938ecd25239e65f519b8d2b50702416edc723de5f0a5387cceea8c4004a44740"

  bottle do
    cellar :any
    sha256 "96d58a07febb18b6ccf1bb33db18337d64e35c1d3eccb79e7228714d4fb58115" => :catalina
    sha256 "5386107af844e51cfa831c28a5fae29aff5be2803dc6ad112a42cd988ed176c4" => :mojave
    sha256 "5e3ae19484999079f571449990150a0b0c9b11224f9a80fd0cc123c96c814dd7" => :high_sierra
  end

  option "without-check", "Disable build-time checking (not recommended)"

  depends_on "cfitsio"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
