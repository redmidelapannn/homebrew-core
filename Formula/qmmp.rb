class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://downloads.sourceforge.net/project/qmmp-dev/qmmp/qmmp-1.3.7.tar.bz2"
  sha256 "e7a996e11b9af2e3bc5634304c5a7144a1d56767177a7cb79a6e50b7ce45b38e"
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.3/"

  bottle do
    sha256 "f88b7608a3dc94f821f39a28a85adec52b14c559c9d95f83a3d859ea103fbfb4" => :catalina
    sha256 "e502a8eb59f74e7ad78872a784483764cf72816d9b64ff8deaf7251df92281e3" => :mojave
    sha256 "ce11f5d78c6308d1a19e42ab5b2ca9807493a6a722d586b2812290bb07cdcd91" => :high_sierra
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

    # fix linkage
    cd (lib.to_s) do
      Dir["*.dylib", "qmmp/*/*.so"].select { |f| File.ftype(f) == "file" }.each do |f|
        MachO::Tools.dylibs(f).select { |d| d.start_with?("/tmp") }.each do |d|
          bname = File.dirname(d)
          d_new = d.sub(bname, opt_lib.to_s)
          MachO::Tools.change_install_name(f, d, d_new)
        end
      end
    end
  end

  test do
    system bin/"qmmp", "--version"
  end
end
