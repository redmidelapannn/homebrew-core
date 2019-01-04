class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v1.9.12.tar.gz"
  sha256 "f4711cb857ea5c409b4602ab2254956d4f24311ed292048f9013163c953e0f30"
  head "https://github.com/falkTX/Carla.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "06add1bace34600d72b4512bb06b8f73786c523f6bdb6949b6443de9182fd595" => :mojave
    sha256 "51d7a73a7fa3d785a282eeb4aed140becfb250a62ec3eead6d9870207e85d8f2" => :high_sierra
    sha256 "e7f1de789e1e0d595cff64eb51deb6945324f93999e2ec604c22a7d2bccbd696" => :sierra
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
