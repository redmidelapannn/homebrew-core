class Hackrf < Formula
  desc "Low cost software radio platform"
  homepage "https://github.com/mossmann/hackrf"
  url "https://github.com/mossmann/hackrf/archive/v2015.07.2.tar.gz"
  sha256 "00eaca20eceb3f2ed4c23c80353b20dac3a29458b8d33654ff287699d2ed8877"
  head "https://github.com/mossmann/hackrf.git"

  bottle do
    cellar :any
    revision 1
    sha256 "7511e1c0362c23f394f17a76f7fa5a5defa097b5f0799944fd1ecd8d452b0d71" => :el_capitan
    sha256 "fcb7b95e51afb906ad79843017b64abaf38f2856965f32fba0571ebe21fa4a35" => :yosemite
    sha256 "a420fb3b52e3f907921e49e079ebfceecdbc18530f4c3dc52b9b9b213c92ed86" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    cd "host" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    shell_output("hackrf_transfer", 1)
  end
end
