class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://ssl.icu-project.org/"
  url "https://ssl.icu-project.org/files/icu4c/62.1/icu4c-62_1-src.tgz"
  mirror "https://downloads.sourceforge.net/project/icu/ICU4C/62.1/icu4c-62_1-src.tgz"
  version "62.1"
  sha256 "3dd9868d666350dda66a6e305eecde9d479fb70b30d5b55d78a1deffb97d5aa3"

  bottle do
    cellar :any
    rebuild 1
    sha256 "93088918ded3cd51173635b09cbaf2cf3737688e19db381476c939eb188b0211" => :mojave
    sha256 "9f5c22e11178c7144ac847fc338b3d932727df456b4e338ed29410d147610041" => :high_sierra
    sha256 "7f6ac2c9690ded1af9e91262b6f4f1d00d7c9cd3a1e572dbe09a9fa3da81458b" => :sierra
  end

  keg_only :provided_by_macos, "macOS provides libicucore.dylib (but nothing else)"

  def install
    args = %W[--prefix=#{prefix} --disable-samples --disable-tests --enable-static]
    args << "--with-library-bits=64" if MacOS.prefer_64_bit?

    cd "source" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/gendict", "--uchars", "/usr/share/dict/words", "dict"
  end
end
