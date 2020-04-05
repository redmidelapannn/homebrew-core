class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-66-1/icu4c-66_1-src.tgz"
  version "66.1"
  sha256 "52a3f2209ab95559c1cf0a14f24338001f389615bf00e2585ef3dbc43ecf0a2e"

  bottle do
    cellar :any
    sha256 "3885d09d3a05043abe4c4ee56766aa39cead0a15c65b5ac1fe0ddf4c312b1ca4" => :catalina
    sha256 "cc7fc71913c480db4ccac1ae7d1b23142227e959fe40fdc6b47f1bae645fcd6d" => :mojave
    sha256 "1c0fcb0c47bdf5232bf737b94e6a5a8eceb12fffde6f4e98cd29eb85d94b3f32" => :high_sierra
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
