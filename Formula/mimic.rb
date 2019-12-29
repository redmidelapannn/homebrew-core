class Mimic < Formula
  desc "Lightweight text-to-speech engine based on CMU Flite"
  homepage "https://mimic.mycroft.ai"
  url "https://github.com/MycroftAI/mimic/archive/1.2.0.2.tar.gz"
  sha256 "619f3864d8ff599c1fa47424b7d87059236fcd51db3c0c311eb3635c80174b5a"
  revision 7

  bottle do
    cellar :any
    sha256 "6d5ccf3c3bae487c9885e4c4d05b0f8fb39c8295e78d9f17852a43aba37da812" => :catalina
    sha256 "7f965a176250af7ae6903ea24b3ab2a082fe0c7b863caa72c98b77d794acffd5" => :mojave
    sha256 "019a9c2c421187b02aa2b12dcfaf3d93c8e774cffc7da2faa3ab0f7299e0c73b" => :high_sierra
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
