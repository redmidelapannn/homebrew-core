class BpmTools < Formula
  desc "Detect tempo of audio files using beats-per-minute (BPM)"
  homepage "http://www.pogo.org.uk/~mark/bpm-tools/"
  url "http://www.pogo.org.uk/~mark/bpm-tools/releases/bpm-tools-0.3.tar.gz"
  sha256 "37efe81ef594e9df17763e0a6fc29617769df12dfab6358f5e910d88f4723b94"
  head "http://www.pogo.org.uk/~mark/bpm-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a88947295e0cf8da50a4de7aa5c7dc92c90bf10aa86bb947ad404ee8d213650a" => :mojave
    sha256 "4c9ca860e2541613e5c87cfc02906a9675e5f26318fb7c8ceb0cd12e3d3e781f" => :high_sierra
    sha256 "de818373ff7067c15db709ba64f11df8bacaf02935754859ff6c14ba4defcde9" => :sierra
    sha256 "0348970a3f89990ed97a15e10dff48f07b853d01d32a640a98e6c835d78f09d7" => :el_capitan
    sha256 "d6bcb8fe9273b0640c2272bd9f4255797eec40a7369362600a62473c3cfd1c27" => :yosemite
    sha256 "702aa6266adb11c4aada4711f32a45e93cd2bff67e62c9d420ecd748d7d80ead" => :mavericks
  end

  def install
    system "make"
    bin.install "bpm"
  end
end
