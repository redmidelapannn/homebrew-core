class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "http://qmmp.ylsoftware.com/"
  url "http://qmmp.ylsoftware.com/files/qmmp-1.2.3.tar.bz2"
  sha256 "32a162b273a61b5d7a568f266d0cc3c3dab63c310d89046280ace42d84ac9816"
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.2/"

  bottle do
    sha256 "02d2a232d361540ed0409a7a50a956dc21bb6f4600294d32eb470bfdb3d54706" => :high_sierra
    sha256 "882c14825528f2b25470bf3135da753c181c5ec1b55c9273b1d037d729427aea" => :sierra
    sha256 "afa299bffaf451023279305dce294d41a922242cc141d8c1ec8dda3200507d74" => :el_capitan
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
