class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/3.6ga5/suite3270-3.6ga5-src.tgz"
  sha256 "bebd0770e23a87997fe1d2353e4f1473aabe461fdddedccbb41fd241e8b5b424"

  bottle do
    rebuild 1
    sha256 "e265ab96725648b1640c5d4d3355481a1cca8e880837442a68a36ab9ee2ea3c9" => :mojave
    sha256 "b8059d798b6a00f060c4a4d6ee30f63053d2fedd23cc0f5c7c3d15fc973ea981" => :high_sierra
    sha256 "a06b96773ef7112a8a24f12548c6b7fa40bd009a68f9bc31e65291b5e5dcf4d6" => :sierra
  end

  depends_on "openssl"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]

    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
