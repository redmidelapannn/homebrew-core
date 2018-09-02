class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "http://qmmp.ylsoftware.com/"
  url "http://qmmp.ylsoftware.com/files/qmmp-1.2.2.tar.bz2"
  sha256 "e9dc5723f7f2a04d36167585ce1b4223c09f36c6dad1215de877dc51d1f3d606"
  revision 1
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.2/"

  bottle do
    sha256 "3aece8898d837d6267563dc44292807a9821c8b9f0b673b864dc71aa85b9cfc5" => :mojave
    sha256 "a4431f3284978d025fa5d7c38d8f4cc793cd524f71d8650415b806b528381b68" => :high_sierra
    sha256 "fa14d5d64cafdfde5da1c70ce5e1f07e13aa77531861fa4fba1d64a55048b65a" => :sierra
    sha256 "47ea13e8530c5bc6f782464ffeae6f47fce170391e62af6e94282b235dc44ae2" => :el_capitan
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
    assert_no_match %r{/tmp}, shell_output("otool -L #{lib}/qmmp/CommandLineOptions/libincdecvolumeoption.so")
    system bin/"qmmp", "--version"
  end
end
