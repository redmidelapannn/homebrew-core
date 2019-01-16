class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v1.9.13.tar.gz"
  sha256 "cc6639dd23b22279f8ab1ae9b51e71d5480b86112c475110daa68cf68fb8cf63"
  revision 1
  head "https://github.com/falkTX/Carla.git"

  bottle do
    cellar :any
    sha256 "f8bb8bbc03840de1155050f7c811d44cd7b73816bdcf8f660392e722856bd604" => :mojave
    sha256 "9d86f7e465074c5015df27b5fdb75ee23d33820e1f66b61752149445a08127c5" => :high_sierra
    sha256 "27965f442e795e4858e854400c628ab6472c4adbfb36ee7f42222c70268e1b3b" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt"
  depends_on "python"

  def install
    args = []
    if ENV.compiler == :clang && MacOS.version <= :mountain_lion
      args << "MACOS_OLD=true"
    end

    system "make", *args
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
