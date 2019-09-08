class BpmTools < Formula
  desc "Detect tempo of audio files using beats-per-minute (BPM)"
  homepage "https://www.pogo.org.uk/~mark/bpm-tools/"
  url "https://www.pogo.org.uk/~mark/bpm-tools/releases/bpm-tools-0.3.tar.gz"
  sha256 "37efe81ef594e9df17763e0a6fc29617769df12dfab6358f5e910d88f4723b94"
  head "https://www.pogo.org.uk/~mark/bpm-tools.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "56e3a889338b82d5b477c1564506e23549d9651b08260d9c9a38b5e6bd1555ab" => :mojave
    sha256 "422342ce8dd8a50853e8289ccc936747f4a77a20803850e6481498cf8c4a12c5" => :high_sierra
    sha256 "f1219d522f61e89606f3e607a636e406faf5f954846b48965e37cc25dbb29b87" => :sierra
  end

  patch do
    # fix tagging mp3s
    # from https://aur.archlinux.org/packages/bpm-tools/#comment-660852
    url "https://gist.githubusercontent.com/eljojo/f26b0e5bc1723e073f7117638fa04998/raw/510f7044b42032a69f968e1e313dea83805b13c4/gistfile1.txt"
    sha256  "5046830c624a66c968de0d5f1d67ba36ee732aa83657e95739f99131b45c3f71"
  end

  def install
    system "make"
    bin.install "bpm"
    bin.install "bpm-tag"
  end
end
