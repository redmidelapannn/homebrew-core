class Mimic < Formula
  desc "Lightweight text-to-speech engine based on CMU Flite"
  homepage "https://mimic.mycroft.ai"
  url "https://github.com/MycroftAI/mimic/archive/1.2.0.2.tar.gz"
  sha256 "619f3864d8ff599c1fa47424b7d87059236fcd51db3c0c311eb3635c80174b5a"
  revision 7

  bottle do
    cellar :any
    sha256 "f5eda1c3e6a1670e9e9caa779a4d1c8bbeb4b0d547f269e166b84deddfaa4244" => :catalina
    sha256 "e9e6708470da01d84dd841a3aceda92e47acde207085c18d6a680f11a68e758a" => :mojave
    sha256 "1065cca33fd211d5212da17a6708b344885a54687f55cb0a0e7594a346fbc641" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "icu4c"
  depends_on "portaudio"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"mimic", "-t", "Hello, Homebrew!", "test.wav"
    assert_predicate testpath/"test.wav", :exist?
  end
end
