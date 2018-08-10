class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "http://qmmp.ylsoftware.com/"
  url "http://qmmp.ylsoftware.com/files/qmmp-1.2.3.tar.bz2"
  sha256 "32a162b273a61b5d7a568f266d0cc3c3dab63c310d89046280ace42d84ac9816"
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.2/"

  bottle do
    sha256 "385b737d34c7a4d316ba330f5a055f0c8caea9421cda50edfdd8db519d0ed95a" => :high_sierra
    sha256 "da3a764a88e2a49452848b5c2567bd79896ce636eaa77a85d3575a8604dc3f4c" => :sierra
    sha256 "ef1208a426327f9fb33a8d1592803b7f07418647e35f0501afc5ccc9acb90135" => :el_capitan
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
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -USE_SKINNED
      -USE_ENCA
      -USE_QMMP_DIALOG
    ]

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"qmmp", "--version"
  end
end
