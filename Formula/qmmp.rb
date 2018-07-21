class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "http://qmmp.ylsoftware.com/"
  url "http://qmmp.ylsoftware.com/files/qmmp-1.2.3.tar.bz2"
  sha256 "32a162b273a61b5d7a568f266d0cc3c3dab63c310d89046280ace42d84ac9816"
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.2/"

  bottle do
    sha256 "ef535d963c62578be167faedc2a717a5ca41e23a1357c7019d517ab24ab2e6a7" => :high_sierra
    sha256 "34519c27ed7c88c4436ef9ef2828980c0242dbbbfcdaac88f2e5f26799b5d047" => :sierra
    sha256 "fbc55a2802c71656c34477c152c426c10aa1490790591211f218a1db597b82ff" => :el_capitan
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
