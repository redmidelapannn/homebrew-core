class Toilet < Formula
  desc "Color-based alternative to figlet (uses libcaca)"
  homepage "http://caca.zoy.org/wiki/toilet"
  url "http://caca.zoy.org/raw-attachment/wiki/toilet/toilet-0.3.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/t/toilet/toilet_0.3.orig.tar.gz"
  sha256 "89d4b530c394313cc3f3a4e07a7394fa82a6091f44df44dfcd0ebcb3300a81de"
  bottle do
    rebuild 1
    sha256 "8bd28dd8819f2d158a286bcd72bd20a3b187410d93df397d05986b7b4b58fada" => :catalina
    sha256 "fda7d10d4917601a88d1288f54d0d9471d07c4f4cec4ee0051fdef312ae27940" => :mojave
    sha256 "fe57ac68d25ef1ae3fcabdc68afdca8b0a4d85134fe9b3f60e9261d11f10df92" => :high_sierra
  end

  head do
    url "https://github.com/cacalabs/toilet.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libcaca"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/toilet", "--version"
  end
end
