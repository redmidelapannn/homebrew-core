class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  head "https://bitbucket.org/breakfastquay/rubberband/", :using => :hg

  stable do
    url "https://breakfastquay.com/files/releases/34/rubberband-1.8.1.tar.bz2"
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
    sha256 "0edcb34c7404c944f00eb041af518dd8b649c35f507f1713dbcdb6c21b070bb9" => :high_sierra
    sha256 "afe0a75ef95ef5aba7013bd10676a502ed6aaad6550e66ec8d05ac7cb3bff05a" => :sierra
    sha256 "55d2bf22d767ab6d0a2848c7909aa965b4729b336cd665b79b02d07f976787b5" => :el_capitan
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
