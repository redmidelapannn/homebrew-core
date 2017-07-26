class OpusTools < Formula
  desc "Utilities to encode, inspect, and decode .opus files"
  homepage "https://www.opus-codec.org"
  url "https://archive.mozilla.org/pub/opus/opus-tools-0.1.10.tar.gz"
  sha256 "a2357532d19471b70666e0e0ec17d514246d8b3cb2eb168f68bb0f6fd372b28c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "01040dd6add783a46e9641d56bab991af802a8ae49bb779d338971d4da56c70d" => :sierra
    sha256 "ccb026e6adb7f0c8f492c22a5ec2c26cf74c7c256a1577fdf791c1a01152a77a" => :el_capitan
    sha256 "45ec5328b4610ce1b57871517f834d47feec24ed79416a0fce6b0583043185be" => :yosemite
  end

  head do
    url "https://git.xiph.org/opus-tools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "opus"
  depends_on "flac"
  depends_on "libogg"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    cp test_fixtures("test.wav"), "test.wav"
    assert_match "Encoding complete", shell_output("#{bin}/opusenc test.wav enc.opus 2>&1")
    assert_predicate testpath/"enc.opus", :exist?, "Failed to encode to enc.opus"
    assert_match "Decoding complete", shell_output("#{bin}/opusdec enc.opus dec.wav 2>&1")
    assert_predicate testpath/"dec.wav", :exist?, "Failed to decode to dec.wav"
  end
end
