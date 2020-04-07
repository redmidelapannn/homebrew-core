class SvtHevc < Formula
  desc "Scalable Video Technology for HEVC Encoder"
  homepage "https://01.org/svt"
  url "https://github.com/OpenVisualCloud/SVT-HEVC/archive/v1.4.3.tar.gz"
  sha256 "08bf2b1075609788194bf983d693ab38ed30214ec966afa67895209fd0bf2179"
  head "https://github.com/OpenVisualCloud/SVT-HEVC.git"

  bottle do
    cellar :any
    sha256 "f41a20395f4a77c1e80f678456a161aa592b572e7a18ae713caa4fc3ca57d89e" => :catalina
    sha256 "1dfcd0ba07c94c448b69fa29ccb4909482d7a4a29b42f03d931b4e7efadb515d" => :mojave
    sha256 "50a4665a000c89ce0ea35ddc9bc34bc2f8457a228a9b71c3f0a9a6bbad1d260d" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build

  resource "akiyo_qcif.y4m" do
    url "https://media.xiph.org/video/derf/y4m/akiyo_qcif.y4m"
    sha256 "df88d83cbf6d99f3ec41f2c1fd2e67665d2a71ff8caa08f8b6bc46bf4567ea2e"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      To avoid error:
        Could not allocate enough memory for channel 1
      Follow instructions here:
        https://github.com/OpenVisualCloud/SVT-AV1/blob/master/README.md#linux-operating-systems-64-bit
    EOS
  end

  test do
    resource("akiyo_qcif.y4m").stage testpath
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    (testpath/"command.sh").write <<~EOS
      #!/bin/sh
      ulimit -n 512
      #{bin}/SvtHevcEncApp -i #{testpath}/akiyo_qcif.y4m -b #{mp4out}
    EOS
    chmod 0555, testpath/"command.sh"
    system "./command.sh"
    assert_predicate mp4out, :exist?
  end
end
