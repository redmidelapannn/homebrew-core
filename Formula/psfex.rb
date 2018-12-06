class Psfex < Formula
  desc "Extracts precise models of the PSFs from images processed by SExtractor"
  homepage "https://www.astromatic.net/software/psfex"
  url "https://github.com/astromatic/psfex/archive/3.21.1.zip"
  sha256 "0716e6be8d701ada0500c3e5e40091d4ac15f85ebd670dc4f937f92812b26b70"

  bottle do
    cellar :any
    sha256 "bbea204dae0dbb015f5696595cf33431cd8d014300e4cad7ca9021bb1ee66d75" => :mojave
    sha256 "40ba2e32224b4ef2fc601e965f4117c96ab9949645abb5448c0d2f707994ee95" => :high_sierra
    sha256 "3e62244cf0371fe7c36e93293a144319f3964f881d6febf0d93caab25e709c7c" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "fftw"
  depends_on "openblas"
  depends_on "plplot"

  def install
    openblas = Formula["openblas"].opt_prefix
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--enable-openblas", "--with-openblas-libdir=#{openblas}/lib", "--with-openblas-incdir=#{openblas}/include"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
