class Timidity < Formula
  desc "Software synthesizer"
  homepage "https://timidity.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/timidity/TiMidity++/TiMidity++-2.14.0/TiMidity++-2.14.0.tar.bz2"
  sha256 "f97fb643f049e9c2e5ef5b034ea9eeb582f0175dce37bc5df843cc85090f6476"

  bottle do
    rebuild 1
    sha256 "dcf0aa1a7937907219f208a65e20497164933cccc3c5beb048375985090e62a7" => :sierra
    sha256 "1c49ba8e72d6b4919c0a754a08607c99e833218e10a18f3cc025dd164622cc01" => :el_capitan
    sha256 "73adf1ab44ef87214c5c5176233ffb1e86dbdf63ebf3e85b52615f94d3cce87a" => :yosemite
  end

  option "without-darwin", "Build without Darwin CoreAudio support"
  option "without-freepats", "Build without the Freepats instrument patches from https://freepats.zenvoid.org/"

  depends_on "libogg" => :recommended
  depends_on "libvorbis" => :recommended
  depends_on "flac" => :recommended
  depends_on "speex" => :recommended
  depends_on "libao" => :recommended

  resource "freepats" do
    url "https://freepats.zenvoid.org/freepats-20060219.zip"
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

    args << "--enable-audio=" + formats.join(",") if formats.any?

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
