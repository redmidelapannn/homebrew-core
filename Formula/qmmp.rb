class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "http://qmmp.ylsoftware.com/"
  url "http://qmmp.ylsoftware.com/files/qmmp-1.1.8.tar.bz2"
  sha256 "17bc88d00ea0753e6fc7273592e894320f05cae807f7cc2c6a5351c73217f010"
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.2/"

  bottle do
    rebuild 1
    sha256 "bfbf9e43c47ec2b4a24b67ca8c820de35d085e702888b678d0c8e6d63828ab33" => :sierra
    sha256 "a8fe3f4ce030f2b122f1763c522cbf2a590bec24dd7ed49fb4e8416e604aa6a6" => :el_capitan
    sha256 "6d08e0928916045dab0965e45326af8d8a8f6d39c324de5a731b81ec83d6a929" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "libogg"
  depends_on "libsoxr"
  depends_on "faad2"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "mplayer"
  depends_on "libbs2b"
  depends_on "libsndfile"
  depends_on "musepack"
  depends_on "taglib"
  depends_on "libmms"
  depends_on "libsamplerate"

  def install
    system "cmake", "./", "-USE_SKINNED", "-USE_ENCA", "-USE_QMMP_DIALOG", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"qmmp", "--version"
  end
end
