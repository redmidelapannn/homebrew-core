class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://ssl.icu-project.org/"
  url "https://ssl.icu-project.org/files/icu4c/63.1/icu4c-63_1-src.tgz"
  mirror "https://github.com/unicode-org/icu/releases/download/release-63-1/icu4c-63_1-src.tgz"
  version "63.1"
  sha256 "05c490b69454fce5860b7e8e2821231674af0a11d7ef2febea9a32512998cb9d"

  bottle do
    cellar :any
    sha256 "577da5f3393608944b8ea79ad7430d444d06cac2d390b2ced684262ea9c126d0" => :mojave
    sha256 "14cd241e5825946f567b7b4b20c9e0e82e4a27d6f35d5a2cbf0181196b54fda4" => :high_sierra
    sha256 "9896e860bb13d9e0a5ce1661cd1f4dd9d4e7bac3b5fbbba6e6cd15ee6a3453ac" => :sierra
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
