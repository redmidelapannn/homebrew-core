class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v1.1.tar.gz"
  sha256 "e11eb93b02f9c75f88182a57b8ab44248ac10ca931cf066e7f02bd1835f2900c"
  head "https://github.com/bavc/qctools.git"

  bottle do
    cellar :any
    sha256 "3009deb94ba804f4d0bca48c24971f95b5edece8259cf067b80ca8acb3d8476e" => :catalina
    sha256 "45468c2115214dec04135f10a02fa82fc9f0e9943b1f6c6a4d66d82585a1bf95" => :mojave
    sha256 "069ea93d8bef4449fdde3b88b2d24c722ae52f4c1c10d2af65c722860012359f" => :high_sierra
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
