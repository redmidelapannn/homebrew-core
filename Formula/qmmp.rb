class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "http://qmmp.ylsoftware.com/"
  url "http://qmmp.ylsoftware.com/files/qmmp-1.2.4.tar.bz2"
  sha256 "224904f073e3921a080dca008e6c99e3d606f5442d1df08835cba000a069ae66"
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.2/"

  bottle do
    rebuild 1
    sha256 "a2e2f5b2dbe6826d891696fe7d445beb8629a3653ca6413e454fb65450c1a070" => :mojave
    sha256 "ef129edea7b26d3e2286361c43f208fb67b91478a40b19c35abcfa36be8466bc" => :high_sierra
    sha256 "abc0c50d6b95889f9dbb72b5e759ac7e4e1c9636eede60c4cf56017982f9bc4f" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libbs2b"
  depends_on "libmms"
  depends_on "libogg"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "mplayer"
  depends_on "musepack"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "qt"
  depends_on "taglib"

  def install
    system "cmake", "./", "-USE_SKINNED", "-USE_ENCA", "-USE_QMMP_DIALOG", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"qmmp", "--version"
  end
end
