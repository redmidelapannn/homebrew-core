class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-65-1/icu4c-65_1-src.tgz"
  version "65.1"
  sha256 "53e37466b3d6d6d01ead029e3567d873a43a5d1c668ed2278e253b683136d948"

  bottle do
    cellar :any
    sha256 "3296efa61633b34b60cf0ea584ae94eccb2bb78b2be77045eb8cb97bc2638db8" => :catalina
    sha256 "296c536ac75b2580ba337a5fb6052e3f24bb1e54657a2447a5f9f9bda28d6629" => :mojave
    sha256 "442beaf8ab414589ea07c670cba8858470ae62eb0a6e5d286a449e960ee8ff50" => :high_sierra
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
