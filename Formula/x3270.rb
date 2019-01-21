class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/3.6ga5/suite3270-3.6ga5-src.tgz"
  sha256 "bebd0770e23a87997fe1d2353e4f1473aabe461fdddedccbb41fd241e8b5b424"

  bottle do
    rebuild 1
    sha256 "243349f5eab3c0568dccac9e907b657ef90daf5b3314b06086f5f4096c21193b" => :mojave
    sha256 "4d581905ef725251224ccd8004232c714db1aee715376ab1c0fc7c64741971c1" => :high_sierra
    sha256 "8d2b755458098bbe85c8b247de32131fa87e3c617b553874610d432b53639698" => :sierra
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

    args << "--enable-x3270" if build.with? "x11"

    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
