class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://downloads.sourceforge.net/project/fluidsynth/fluidsynth-1.1.6/fluidsynth-1.1.6.tar.gz"
  sha256 "50853391d9ebeda9b4db787efb23f98b1e26b7296dd2bb5d0d96b5bccee2171c"

  bottle do
    cellar :any
    rebuild 2
    sha256 "31db20e9f0c19ce095a0dd1a6c40184e18436c4650039bc11a09cc2c6f29d9db" => :sierra
    sha256 "ce500fb4188e81304ed3a5e5772b1b8eca1a6cddde176c5329baa6486d210ec9" => :el_capitan
    sha256 "977c64a8ad50b24c1a007c933ea055bcaaf395136d30bf03b4e9047cc1602b6a" => :yosemite
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "libsndfile" => :optional
  depends_on "portaudio" => :optional

  def install
    ENV.universal_binary if build.universal?

    args = std_cmake_args
    args << "-Denable-framework=OFF" << "-DLIB_SUFFIX="
    args << "-Denable-portaudio=ON" if build.with? "portaudio"
    args << "-Denable-libsndfile=OFF" if build.without? "libsndfile"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/fluidsynth --version")
  end
end
