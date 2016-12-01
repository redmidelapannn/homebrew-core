class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/"
  url "https://ssl.icu-project.org/files/icu4c/58.1/icu4c-58_1-src.tgz"
  mirror "https://nuxi.nl/distfiles/third_party/icu4c-58_1-src.tgz"
  version "58.1"
  sha256 "0eb46ba3746a9c2092c8ad347a29b1a1b4941144772d13a88667a7b11ea30309"

  head "https://ssl.icu-project.org/repos/icu/trunk/icu4c/", :using => :svn

  bottle do
    cellar :any
    rebuild 1
    sha256 "3da65debe0a5beddb65fbe5ff5efe9aba636efb84d7f0f815ff2e67c26474d99" => :sierra
    sha256 "1a9ad8d988fe668e941623e69c5dd0287a22377bff6852b793cda2159255e29b" => :el_capitan
    sha256 "3928b53847819d6bcf9a144ec58d7f46f85cccf76f4ed62deeef4961d614fa99" => :yosemite
  end

  keg_only :provided_by_osx, "macOS provides libicucore.dylib (but nothing else)."

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
    # CI dependancy
    ENV["LANG"] = "en_US.UTF-8"
    system "#{bin}/gendict", "--uchars", "/usr/share/dict/words", "dict"
  end
end
