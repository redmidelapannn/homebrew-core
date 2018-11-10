class Mimic < Formula
  desc "Lightweight text-to-speech engine based on CMU Flite"
  homepage "https://mimic.mycroft.ai"
  url "https://github.com/MycroftAI/mimic/archive/1.2.0.2.tar.gz"
  sha256 "6adcc9911b09d6e9513add41ad9dfc0893ece277f556419869520a0f0708c102"
  revision 5

  bottle do
    cellar :any
    sha256 "cbeca8df6f3ccf07164b8133af86dffac08ff6433847847cf6aead89fa920a79" => :mojave
    sha256 "fde8d25df74ce4b06294066cc2e162167089cb7f3972020429cb63ea0c360397" => :high_sierra
    sha256 "68faa0e11d7ffa277696b4df934eac8724d32882123e86a6e9dbb71fd77f50d3" => :sierra
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
