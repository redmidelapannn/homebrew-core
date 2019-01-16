class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.0.3.tar.gz"
  sha256 "12c7ede220f54a6e52a7e7b0b1729c04a4282685569adf18d932a7dd3c10e759"
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    cellar :any
    sha256 "bfbcfdb3a910769728c1a4be0aa7b6784a73004565eabfd4e8cd2befbc22d46c" => :mojave
    sha256 "2324f827f44ff9da0da91a83c3f01d921346140c50a3648c1673c192c19eed0e" => :high_sierra
    sha256 "30296a5ddb6dd60d8231fa867713f954b190785c373bfb8e99c835cfb10bd9cb" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsndfile"
  depends_on "portaudio"

  def install
    args = std_cmake_args + %w[
      -Denable-framework=OFF
      -Denable-portaudio=ON
      -DLIB_SUFFIX=
      -Denable-dbus=OFF
      -Denable-sdl2=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/fluidsynth --version")
  end
end
