class Espeak < Formula
  desc "Text to speech, software speech synthesizer"
  homepage "http://espeak.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/espeak/espeak/espeak-1.48/espeak-1.48.04-source.zip"
  sha256 "bf9a17673adffcc28ff7ea18764f06136547e97bbd9edf2ec612f09b207f0659"
  revision 1

  bottle do
    rebuild 2
    sha256 "9af8f9ab67c106d0c612e9de5def0bbe12921663cd5e703f854c35da3b587719" => :sierra
    sha256 "82af5047ff9c3193c7467ee2e637d95dde4c9a9d7d903cc758a137a88eb84569" => :el_capitan
    sha256 "578c8c30f1f0f583aaf5f1ea7382642b98b856f4613354581461a7d1c1a03d2b" => :yosemite
  end

  depends_on "portaudio"

  def install
    share.install "espeak-data"
    doc.install Dir["docs/*"]
    cd "src" do
      rm "portaudio.h"
      inreplace "Makefile", "SONAME_OPT=-Wl,-soname,", "SONAME_OPT=-Wl,-install_name,"
      # macOS does not use -soname so replacing with -install_name to compile for macOS.
      # See https://stackoverflow.com/questions/4580789/ld-unknown-option-soname-on-os-x/32280483#32280483
      inreplace "speech.h", "#define USE_ASYNC", "//#define USE_ASYNC"
      # macOS does not provide sem_timedwait() so disabling #define USE_ASYNC to compile for macOS.
      # See https://sourceforge.net/p/espeak/discussion/538922/thread/0d957467/#407d
      system "make", "speak", "DATADIR=#{share}/espeak-data", "PREFIX=#{prefix}"
      bin.install "speak" => "espeak"
      system "make", "libespeak.a", "DATADIR=#{share}/espeak-data", "PREFIX=#{prefix}"
      lib.install "libespeak.a"
      system "make", "libespeak.so", "DATADIR=#{share}/espeak-data", "PREFIX=#{prefix}"
      lib.install "libespeak.so.1.1.48" => "libespeak.dylib"
      MachO::Tools.change_dylib_id("#{lib}/libespeak.dylib", "#{lib}/libespeak.dylib")
      # macOS does not use the convention libraryname.so.X.Y.Z. macOS uses the convention libraryname.X.dylib
      # See https://stackoverflow.com/questions/4580789/ld-unknown-option-soname-on-os-x/32280483#32280483
    end
  end

  test do
    system "#{bin}/espeak", "This is a test for Espeak.", "-w", "out.wav"
  end
end
