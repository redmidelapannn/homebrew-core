class BpmTools < Formula
  desc "Detect tempo of audio files using beats-per-minute (BPM)"
  homepage "https://www.pogo.org.uk/~mark/bpm-tools/"
  url "https://www.pogo.org.uk/~mark/bpm-tools/releases/bpm-tools-0.3.tar.gz"
  sha256 "37efe81ef594e9df17763e0a6fc29617769df12dfab6358f5e910d88f4723b94"
  head "https://www.pogo.org.uk/~mark/bpm-tools.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "3d18e8d0b909b32ac5c40d1a553d255ac5b1c161b8e246aeab26e40ce7144151" => :mojave
    sha256 "5199e77f7868c8848d5251d01cc1aba832dcb100620218966b70a2b9d8494e32" => :high_sierra
    sha256 "ae14353b4c7f1b5e77c9492ceff4e4f0f43f120556a36a52e456b238fedd39da" => :sierra
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
