class Rkdeveloptool < Formula
  desc "This tool gives you a simple way to read/write Rockchip devices"
  homepage "http://opensource.rock-chips.com/wiki_Rkdeveloptool"
  url "https://github.com/rockchip-linux/rkdeveloptool/archive/72c04fec88b2a3c6136a4aee4747e41c531c4f4b.tar.gz"
  version "1.3"
  sha256 "c2c3a3cc325ccf840e4054d05a794144417dabed8725d9f1e66125b493124865"

  bottle do
    cellar :any
    sha256 "94d91709830ad2ab02d7e1ee03e0b4dfb9bbde18f03410abb1f112436b0b6ffe" => :mojave
    sha256 "6c4e7160b8581d8bbb19caec4c31aa766a58cd48352064a681cf11d31b36b080" => :high_sierra
    sha256 "28e9ecf7292c9d18c5c943a1ef68ab34e91c4e17ee92b45662bebb90760a8ef7" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rkdeveloptool", "-v"
  end
end
