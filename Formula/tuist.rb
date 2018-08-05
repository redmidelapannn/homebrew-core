class Tuist < Formula
  desc "Generate, maintain, and interact with Xcode projects easily"
  homepage "https://tuist.io"
  url "https://github.com/tuist/tuist/raw/0.2.0/bin/tuistenv"
  sha256 "6769e784ade1a6c5726a71afc78b13dd1509f2b421deb6719fd2ff9ab796afda"

  bottle do
    cellar :any_skip_relocation
    sha256 "a36bbc4f487857b8212c26d80b9d4149acf554f91bd40f8d6060f3b407da0297" => :high_sierra
    sha256 "ffa895fbbeed5e79a301f4ab533fad2c1a643360d013df80d1312ca37be2e355" => :sierra
    sha256 "9d5e23081526dafdf4c751006877f4d6e98de5a3c8b459ea197672bb5caaaca8" => :el_capitan
  end

  def install
    File.rename("tuistenv", "tuist")
    bin.install "tuist"
  end

  test do
    # Shows all available commands
    system "#{bin}/tuist", "--help-env"
    # Pins tuist to the given version
    system "#{bin}/tuist", "local", "0.2.0"
  end
end
