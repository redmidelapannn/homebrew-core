class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-64-2/icu4c-64_2-src.tgz"
  version "64.2"
  sha256 "627d5d8478e6d96fc8c90fed4851239079a561a6a8b9e48b0892f24e82d31d6c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0be18544e62befd1a5155c36edd014ca6bb57f16109485d6722f2030f8bf40b7" => :catalina
    sha256 "20de87c65a513fc9d62378ad4053096d630eb5becdfa70c2afd45f30dd418260" => :mojave
    sha256 "2afdd972f96d1baae9d873279404be690a4d6a57c83a1da233bd61da32b4bcc4" => :high_sierra
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
