class HidListen < Formula
  desc "Prints out debugging information from usb hid devices"
  homepage "https://www.pjrc.com/teensy/hid_listen.html"
  url "https://github.com/PaulStoffregen/hid_listen/archive/1.01.tar.gz"
  sha256 "4cb44c8fb0b5dab1c7acee5920c298bd4b193ada25fa186a5b9aff08ed48ba43"

  bottle do
    cellar :any_skip_relocation
    sha256 "66ca3d470d08927799812de92351d22e0285d2667b65832cf7441259b9acccb8" => :high_sierra
    sha256 "6b461d4c60eb817723338bbec566edb8355c4513e272dc31a75563d92bb8e01b" => :sierra
    sha256 "c3465fbc92cc2ba1363d072211c4c8017387285cdf9480a61c166b6f70426ba4" => :el_capitan
  end

  def install
    system "make", "OS=DARWIN", "hid_listen"
    bin.install "hid_listen"
  end

  test do
    system "true"
  end
end
