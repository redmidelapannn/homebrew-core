class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.4.2/chromaprint-1.4.2.tar.gz"
  sha256 "989609a7e841dd75b34ee793bd1d049ce99a8f0d444b3cea39d57c3e5d26b4d4"
  revision 1
  head "https://github.com/acoustid/chromaprint.git"

  bottle do
    cellar :any
    sha256 "890628e5055a7e5c651fa07c58a229fb25ff5f36ed639d0bae9502094daafa8e" => :sierra
    sha256 "939aca1d699b942c2fbd65eeb1b4a2dfd4cc2a4830a379413234a540209b7b19" => :el_capitan
    sha256 "0e695ee7bcb2f12718c9f2148c7c491752ae5533490313775cffe4306a56f160" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg" => :recommended

  def install
    options = std_cmake_args.dup
    options << "-DBUILD_TOOLS=ON" if build.with?("ffmpeg")
    system "cmake", ".", *options
    system "make", "install"
  end

  test do
    if build.with?("ffmpeg")
      out = shell_output("#{bin}/fpcalc -json -format s16le -rate 44100 -channels 2 -length 10 /dev/zero")
      assert_equal "AQAAO0mUaEkSRZEGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", JSON.parse(out)["fingerprint"]
    end
  end
end
