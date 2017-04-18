class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/"
  url "https://ssl.icu-project.org/files/icu4c/59.1/icu4c-59_1-src.tgz"
  mirror "https://fossies.org/linux/misc/icu4c-59_1-src.tgz"
  version "59.1"
  sha256 "7132fdaf9379429d004005217f10e00b7d2319d0fea22bdfddef8991c45b75fe"
  head "https://ssl.icu-project.org/repos/icu/trunk/icu4c/", :using => :svn

  bottle do
    cellar :any
    sha256 "654bff9a4f9b49babf15287fa6fdc07f40e86d4fe10c2408ecdefab827a7b428" => :sierra
    sha256 "3daabf0b5f458696ae535da80b0b1c84b77c5a566e2bfacff9d8d5bb8abb65ae" => :el_capitan
    sha256 "30700377a3fc2aadf5023b409807d438da347c68123e0a7373a37f88683ab8c1" => :yosemite
  end

  keg_only :provided_by_osx, "macOS provides libicucore.dylib (but nothing else)."

  needs :cxx11

  def install
    ENV.cxx11

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
