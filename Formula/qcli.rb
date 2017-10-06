class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v0.9.tar.gz"
  sha256 "19ef4be054ebfca70a07043afea20bcca241ba08d70a47acda837ead849aff03"
  head "https://github.com/bavc/qctools.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "44e18ba0cb0171d3a8793d1250bee7ad65c892c24a954bb3083707a4c75ee319" => :high_sierra
    sha256 "251d2628c05049a958c0dcab1459a19f2d7e35c92924ff7c9633240110e3eeec" => :sierra
    sha256 "e020c848745dfed82f0ad2bb6e826bb66b067efd00523a79db46a633bacbb0cf" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "qwt"
  depends_on "qt"
  depends_on "ffmpeg"

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
