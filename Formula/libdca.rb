class Libdca < Formula
  desc "Library for decoding DTS Coherent Acoustics streams"
  homepage "https://www.videolan.org/developers/libdca.html"
  url "https://download.videolan.org/pub/videolan/libdca/0.0.7/libdca-0.0.7.tar.bz2"
  sha256 "3a0b13815f582c661d2388ffcabc2f1ea82f471783c400f765f2ec6c81065f6a"

  bottle do
    cellar :any
    sha256 "222a0b9973e02de9c4e1495e3c508f3fe250758a5cf33f9fa96154623db91685" => :catalina
    sha256 "c204cb723be649039a1eb344245da22a90d4a55ace3e0d742fe566546ec40f83" => :mojave
    sha256 "d17a459be7227e71c8a68811d77031cb1d41f2cb790d0c13a60d5527948acc53" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # Fixes "duplicate symbol ___sputc" error when building with clang
    # https://github.com/Homebrew/homebrew/issues/31456
    ENV.append_to_cflags "-std=gnu89"

    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
