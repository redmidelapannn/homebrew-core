class Timidity < Formula
  desc "Software synthesizer"
  homepage "https://timidity.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/timidity/TiMidity++/TiMidity++-2.14.0/TiMidity++-2.14.0.tar.bz2"
  sha256 "f97fb643f049e9c2e5ef5b034ea9eeb582f0175dce37bc5df843cc85090f6476"

  bottle do
    rebuild 1
    sha256 "e697f69aac8431da49068dd6fc150b4185c168aa765f41b37726f6f212b21b8b" => :sierra
    sha256 "a30070bf39821bdd574ae79f9c1c21762f591a42c79e9fc151725fda78a95281" => :el_capitan
    sha256 "3c719d12018ab0ebefc1850583b9f0ee4364a33b626f649063bad3e4843b7f7f" => :yosemite
  end

  option "without-darwin", "Build without Darwin CoreAudio support"
  option "without-freepats", "Build without the Freepats instrument patches from http://freepats.zenvoid.org/"

  depends_on "libogg" => :recommended
  depends_on "libvorbis" => :recommended
  depends_on "flac" => :recommended
  depends_on "speex" => :recommended
  depends_on "libao" => :recommended

  resource "freepats" do
    url "http://freepats.zenvoid.org/freepats-20060219.zip"
    sha256 "532048a5777aea717effabf19a35551d3fcc23b1ad6edd92f5de1d64600acd48"
  end

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--mandir=#{man}"]

    formats = []
    formats << "darwin" if build.with? "darwin"
    formats << "vorbis" if build.with?("libogg") && build.with?("libvorbis")
    formats << "flac" if build.with? "flac"
    formats << "speex" if build.with? "speex"
    formats << "ao" if build.with? "libao"

    if formats.any?
      args << "--enable-audio=" + formats.join(",")
    end

    system "./configure", *args
    system "make", "install"

    if build.with? "freepats"
      (share/"freepats").install resource("freepats")
      pkgshare.install_symlink share/"freepats/Tone_000",
                               share/"freepats/Drum_000",
                               share/"freepats/freepats.cfg" => "timidity.cfg"
    end
  end

  test do
    system "#{bin}/timidity"
  end
end
