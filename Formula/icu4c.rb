class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-65-1/icu4c-65_1-src.tgz"
  version "65.1"
  sha256 "53e37466b3d6d6d01ead029e3567d873a43a5d1c668ed2278e253b683136d948"

  bottle do
    cellar :any
    sha256 "86ffd1c673445ea70c1f461f4afe484842da79b013e523e3348928a191090a2b" => :catalina
    sha256 "4866028197dab9c0fdff7aae8be6d85b66dfa4e773663c3d2c030489176a6425" => :mojave
    sha256 "1336c116739778418168350e573c65db3e12572de78850543e1900c49ff64014" => :high_sierra
  end

  keg_only :provided_by_macos, "macOS provides libicucore.dylib (but nothing else)"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-samples
      --disable-tests
      --enable-static
      --with-library-bits=64
    ]

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
