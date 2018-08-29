class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/carla", :using => :git, :tag => "v1.9.9", :revision => "c03571a9ef95ac0e9564b95347f5de819aa7fb54"
  revision 0

  depends_on "pkg-config" => :build
  depends_on :macos => :mavericks
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt"
  depends_on "python"

  def install
    args = %W[
      PREFIX=#{prefix}
    ]

    # list all available carla features based on dependencies
    system "make"
    system "make", "install", *args
  end

  test do
    system bin/"carla", "--version"
  end
end
