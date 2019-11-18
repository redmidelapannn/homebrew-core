class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v2.0.9.tar.gz"
  sha256 "bfe82ccf1bf00ff5cfc18e2d9d1e5d95c6bd169a76a2dec14898d1ee0e0fac8a"
  head "https://github.com/FluidSynth/fluidsynth.git"

  bottle do
    cellar :any
    sha256 "cf5969c88c2d9285017c266c43052ad6b090ce14bab8f56a670e385c53f1e937" => :catalina
    sha256 "ab0c43ab43c4021e1ad101ac9dce0decbb12d60ba386b59c3bb57cabc5162580" => :mojave
    sha256 "ea6b3682a1d516a2bd2f5875ce31bcbdf275495b1375f6d42743c5d2527b5a64" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsndfile"
  depends_on "portaudio"

  resource "example_midi" do
    url "https://upload.wikimedia.org/wikipedia/commons/6/61/Drum_sample.mid"
    sha256 "a1259360c48adc81f2c5b822f221044595632bd1a76302db1f9d983c44f45a30"
  end

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

    pkgshare.install "sf2"
  end

  test do
    resource("example_midi").stage testpath
    system bin/"fluidsynth", "-acoreaudio",
                             "-mcoremidi",
                             "-i", "-g0",
                             pkgshare/"sf2/VintageDreamsWaves-v2.sf2",
                             "Drum_sample.mid"
  end
end
