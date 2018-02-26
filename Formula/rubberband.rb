class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "http://breakfastquay.com/rubberband/"
  head "https://bitbucket.org/breakfastquay/rubberband/", :using => :hg

  stable do
    url "http://code.breakfastquay.com/attachments/download/34/rubberband-1.8.1.tar.bz2"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/r/rubberband/rubberband_1.8.1.orig.tar.bz2"
    sha256 "ff0c63b0b5ce41f937a8a3bc560f27918c5fe0b90c6bc1cb70829b86ada82b75"

    # replace vecLib.h by Accelerate.h
    # already fixed in upstream:
    # https://bitbucket.org/breakfastquay/rubberband/commits/cb02b7ed1500f0c06c0ffd196921c812dbcf6888
    # https://bitbucket.org/breakfastquay/rubberband/commits/9e32f693c6122b656a0df63bc77e6a96d6ba213d
    patch :p1 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/1fd51a983/rubberband/rubberband-1.8.1-yosemite.diff"
      sha256 "7686dd9d05fddbcbdf4015071676ac37ecad5c7594cc06470440a18da17c71cd"
    end
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "49f2096e068a8f38763b1c0d86719d46a01677cb425c6fb2296cffbdc4b48e65" => :high_sierra
    sha256 "494e61de397bc846f69b9152d0ad2b2db883dffffc5fa43243aaf54d03ba6cd3" => :sierra
    sha256 "8507f896c828f76fa783a6de5d3f44619989ce1de9d6be55f3406f6beded2263" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libsamplerate"
  depends_on "libsndfile"

  def install
    system "make", "-f", "Makefile.osx"
    bin.install "bin/rubberband"
    lib.install "lib/librubberband.dylib"
    include.install "rubberband"

    cp "rubberband.pc.in", "rubberband.pc"
    inreplace "rubberband.pc", "%PREFIX%", opt_prefix
    (lib/"pkgconfig").install "rubberband.pc"
  end

  test do
    output = shell_output("#{bin}/rubberband -t2 #{test_fixtures("test.wav")} out.wav 2>&1")
    assert_match "Pass 2: Processing...", output
  end
end
