class Mtn < Formula
  desc "Saves thumbnails (screenshots) of movie or video files to jpeg files"
  homepage "https://gitlab.com/movie_thumbnailer/mtn/wikis/home"
  url "https://gitlab.com/movie_thumbnailer/mtn/-/archive/3.3.2/mtn-3.3.2.tar.gz"
  sha256 "471ec0172a1753d684032edb8296ef01af115538619daa417678ac037328daf5"

  bottle do
    cellar :any
    sha256 "10cc46631649299f0ff385e440531298b659e7035dfc039ebf348a5089c30f66" => :mojave
    sha256 "0a39b13209580dea4c75d2ffaad77b4c46e139cae26b5e5685316289c90230d9" => :high_sierra
    sha256 "92cf3c396477016008079d49d2c3bacc54ecd6fb84b88b4e7cfa86e6d3ad1286" => :sierra
  end

  depends_on "ffmpeg"
  depends_on "gd"

  def install
    system "make", "-Csrc", "install", "PREFIX=#{prefix}"
  end

  test do
    system "curl", "--output", "sample.avi", "-L", "https://bitbucket.org/wahibre/mtn/downloads/sample.avi"
    system "echo '918243383bc9a3a8ff37da451f4b6b17f9636769  sample_s.jpg' > checksum"
    system "#{bin}/mtn", "sample.avi"
    system "shasum", "--check", "checksum"
  end
end
