class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "http://www.wavpack.com/"
  url "http://www.wavpack.com/wavpack-5.1.0.tar.bz2"
  sha256 "1939627d5358d1da62bc6158d63f7ed12905552f3a799c799ee90296a7612944"

  bottle do
    cellar :any
    rebuild 1
    sha256 "368409036192661f6aa80e6acf38ae9ebd427784cc590f4e770cf1a8ee6cae86" => :high_sierra
    sha256 "29e155391c97d888edc186b1945aa78653bed8ca82c05f043cd08e5289e161f4" => :sierra
    sha256 "e482982e167d8d4dc8bf57c6bdbfd53a1c0a16b46c7a9ca3fb1311635c008926" => :el_capitan
  end

  head do
    url "https://github.com/dbry/WavPack.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    args = %W[--prefix=#{prefix} --disable-dependency-tracking]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system bin/"wavpack", test_fixtures("test.wav"), "-o", testpath/"test.wv"
    assert_predicate testpath/"test.wv", :exist?
  end
end
