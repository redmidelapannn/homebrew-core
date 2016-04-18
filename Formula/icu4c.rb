class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/"
  url "https://ssl.icu-project.org/files/icu4c/57.1/icu4c-57_1-src.tgz"
  mirror "https://fossies.org/linux/misc/icu4c-57_1-src.tgz"
  version "57.1"
  sha256 "ff8c67cb65949b1e7808f2359f2b80f722697048e90e7cfc382ec1fe229e9581"
  revision 1

  head "https://ssl.icu-project.org/repos/icu/icu/trunk/", :using => :svn

  bottle do
    cellar :any
    sha256 "c2169eb86622e7f2c310ba2591290312a3e6fcb5e8ec19631b6072bd78914eeb" => :el_capitan
    sha256 "4af0ed955e60e88e88f7edcb99d6fff91c4cc649c5e4c2bd0381132b2e3ebd40" => :yosemite
    sha256 "85f75a49f734527c9d50841d7756a52879d73cc4274a5ff858b70bb6336a0df6" => :mavericks
  end

  keg_only :provided_by_osx, "OS X provides libicucore.dylib (but nothing else)."

  option :universal
  option :cxx11

  def install
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?

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
