class Liblastfm < Formula
  desc "Libraries for Last.fm site services"
  homepage "https://github.com/lastfm/liblastfm/"
  url "https://github.com/lastfm/liblastfm/archive/1.0.9.tar.gz"
  sha256 "5276b5fe00932479ce6fe370ba3213f3ab842d70a7d55e4bead6e26738425f7b"
  revision 3

  bottle do
    cellar :any
    sha256 "1320c717068b006414a6c5f51b3e7a4157680635daf3ec376f2a55959482f309" => :mojave
    sha256 "4f50aef25d93b0734d8f878acd89a1399244747cacb384ad3a66f90097584396" => :high_sierra
    sha256 "6c384c4fff700346a7e27d45efa24fdae5dc3ff868676458518e5c4200b41b2a" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "libsamplerate"
  depends_on "qt"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
      cd "tests" do
        system "make"
      end
      share.install "tests"
    end
  end

  test do
    cp_r "#{share}/tests/.", testpath
    system "./TrackTest"
  end
end
