class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v1.0.tar.gz"
  sha256 "4b687eb9aedf29a8262393079669d3870c04b510669b9df406021243b8ebd918"
  revision 1
  head "https://github.com/bavc/qctools.git"

  bottle do
    cellar :any
    sha256 "60b6e56408fcda8d603e4776735e63eb052d8598f926d1dae2c026e12745bbb0" => :catalina
    sha256 "06a0109132d4fa0e47594bfd3ca5267bbb9b26a2828274a9d22b0369ab473e9d" => :mojave
    sha256 "8a615eec22d422f714bc1983eba2199b9501a0fb60bc722c47b77387b38c3149" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "qt"
  depends_on "qwt"

  def install
    ENV["QCTOOLS_USE_BREW"]="true"

    cd "Project/QtCreator/qctools-lib" do
      system "qmake", "qctools-lib.pro"
      system "make"
    end
    cd "Project/QtCreator/qctools-cli" do
      system "qmake", "qctools-cli.pro"
      system "make"
      bin.install "qcli"
    end
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system "ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    # Create a qcli report from the mp4
    qcliout = testpath/"video.mp4.qctools.xml.gz"
    system bin/"qcli", "-i", mp4out, "-o", qcliout
    assert_predicate qcliout, :exist?
  end
end
