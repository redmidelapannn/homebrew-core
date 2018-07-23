class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/"
  url "https://ssl.icu-project.org/files/icu4c/62.1/icu4c-62_1-src.tgz"
  mirror "https://downloads.sourceforge.net/project/icu/ICU4C/62.1/icu4c-62_1-src.tgz"
  version "62.1"
  sha256 "3dd9868d666350dda66a6e305eecde9d479fb70b30d5b55d78a1deffb97d5aa3"

  bottle do
    cellar :any
    rebuild 1
    sha256 "73596184eb19f40510ccef6932cc0fa012cf7e09e20ba165ef2f40bcfb8634db" => :high_sierra
    sha256 "be1e1770cae0140eb68999181ffbb78c3f815cc6825f9f6df901dd9f8a3d13e9" => :sierra
    sha256 "399b043986e5ba5db303bc3aa708557c66b407b2d83c24f7bc5261e55936eb9d" => :el_capitan
  end

  head do
    url "https://github.com/unicode-org/icu.git"
    depends_on "git-lfs" => :build
  end

  keg_only :provided_by_macos, "macOS provides libicucore.dylib (but nothing else)"

  def install
    args = %W[--prefix=#{prefix} --disable-samples --disable-tests --enable-static]
    args << "--with-library-bits=64" if MacOS.prefer_64_bit?

    cd "icu4c" if build.head?

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
