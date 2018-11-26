class Libcaption < Formula
  desc "Library for the creation and parsing of closed caption data"
  homepage "https://github.com/szatmary/libcaption"

  url "https://github.com/szatmary/libcaption/archive/0.7.tar.gz"
  sha256 "125c9c55e1d5f0dc37ef151fa9583dd2fcfaefe7699d348c7292e634859e527e"

  bottle do
    cellar :any_skip_relocation
    sha256 "168b3b0a20913aa18df1a9dd9af93644497574f9221d57030c405768a082dd77" => :mojave
    sha256 "23ccd33a7007d02796b6750fbd7bf526487dd8b450c475493cb7e3fd6f22f7ad" => :high_sierra
    sha256 "cfc5c5cb0f7446001f159ec71f7e417556851c4ef3c5544bbf5b747e575c4421" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg" => [:build, :test]
  depends_on "re2c" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # Create an FLV video file
    INPUT_VIDEO = testpath/"input_video.flv"
    system "ffmpeg", "-report", "-hide_banner",
    "-f", "lavfi", "-i", "smptebars=duration=2:size=640x360:rate=30",
    "-c:v", "libx264", "-crf", "23", "-preset", "ultrafast",
    "-f", "flv", INPUT_VIDEO

    INPUT_CAPTION_FILE = testpath/"input_caption.srt"
    INPUT_CAPTION_FILE.write <<~EOS
      1
      00:00:00,000 --> 00:00:02,000
      Caption Text
    EOS
    OUTPUT_FILE = testpath/"output.flv"
    system bin/"flv+srt", INPUT_VIDEO, INPUT_CAPTION_FILE, OUTPUT_FILE
    assert_predicate OUTPUT_FILE, :exist?
  end
end
