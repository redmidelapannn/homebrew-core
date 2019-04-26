class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.0.0.tar.gz"
  sha256 "d0c8d8417f8cce9abe807f6359231f187d60db7121ec1dccce3b596a22ef6c41"
  revision 1
  head "https://github.com/falkTX/Carla.git"

  bottle do
    cellar :any
    sha256 "150e062705cbdebbd0ca460b7d4f71a6d2b6f6dfd9b08b72c4847dbd3421e7a9" => :mojave
    sha256 "89f6ce2cdd9b784fc128adabf790e810c373aabaa7b6a3e47130cec2b99069d8" => :high_sierra
    sha256 "174a5ee6b0ed06901043e058765ac5a9487f9a637e86dcced1b2f5656c523f3c" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt"
  depends_on "python"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
