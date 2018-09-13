class Timidity < Formula
  desc "Software synthesizer"
  homepage "https://timidity.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/timidity/TiMidity++/TiMidity++-2.14.0/TiMidity++-2.14.0.tar.bz2"
  sha256 "f97fb643f049e9c2e5ef5b034ea9eeb582f0175dce37bc5df843cc85090f6476"

  bottle do
    rebuild 1
    sha256 "3099d9e1ec57d86cdee93ca67482b291ca78052508ff5e8d42ed0fb4a6c5937b" => :mojave
    sha256 "ded80b4d14cd5b80445922aaa5087c1e5869269e14106b0d57f15a616194f32a" => :high_sierra
    sha256 "cc6e9f20b6611403642be99d8c3163e7ef3143d154f0c2a44352b1ac3c1d84fc" => :sierra
    sha256 "52b0ace12e53fd3843ebd73ae96c7e104074bf9826656caec209f991fb99ee99" => :el_capitan
  end

  depends_on "flac"
  depends_on "libao"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "speex"

  resource "freepats" do
    url "https://freepats.zenvoid.org/freepats-20060219.zip"
    sha256 "532048a5777aea717effabf19a35551d3fcc23b1ad6edd92f5de1d64600acd48"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-audio=darwin,vorbis,flac,speex,ao"
    system "make", "install"

    # Freepats instrument patches from https://freepats.zenvoid.org/
    (share/"freepats").install resource("freepats")
    pkgshare.install_symlink share/"freepats/Tone_000",
                             share/"freepats/Drum_000",
                             share/"freepats/freepats.cfg" => "timidity.cfg"
  end

  test do
    system "#{bin}/timidity"
  end
end
